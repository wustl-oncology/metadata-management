
require 'csv' 
class ImportSampleData < ApplicationJob
  attr_reader :upload, :errors

  def perform(upload)
    @errors = Hash.new { |h, k| h[k] = [] }
    @upload = upload
    first_row = true

    add_step('Checking File')
    ActiveRecord::Base.transaction do
      upload.sample_file.open do |file|
        CSV.foreach(file, col_sep: "\t", headers: true, row_sep: :auto).with_index do |row, i|
          if first_row
            break unless validate_headers(row.headers)
            first_row = false
          end
          row_validator = UploadedRow.new(row, upload.project)
          row_validator.persist_row
          if row_validator.errors.any?
            errors["row_#{i+1}"] = row_validator.errors
          end
        end
      end

      if any_errors?
        raise ActiveRecord::Rollback
      end
    end
  rescue StandardError => e
    errors[:general] << e.message
  ensure
    convey_result
    cleanup
  end

  private
  def validate_headers(headers)
    update_message("Validating Headers..")

    if headers != Upload.expected_headers
      missing_headers = Upload.expected_headers - headers
      if missing_headers.any?
        errors[:headers] << "Expected to find #{missing_headers.join(', ')} headers but did not."
      end
      extra_headers = headers - Upload.expected_headers
      if extra_headers.any?
        errors[:headers] << "Found unexpected headers: #{extra_headers.join(', ')}."
      end
    end

    if errors[:headers].none?
      update_message("Validating Rows..")
      add_step('Headers Validated')
      return true
    else
      add_step('Invalid Headers Detected', :error)
      return false
    end
  end

  def convey_result
    if any_errors?
      Turbo::StreamsChannel.broadcast_update_to(
        upload,
        target: "import-result",
        partial: 'uploads/error-result',
        locals: {errors: errors, project: upload.project}
      )
      update_message('Import Failed')
    else
      Turbo::StreamsChannel.broadcast_update_to(
        upload,
        target: "import-result",
        partial: 'uploads/success-result',
        locals: {project: upload.project}
      )
      update_message('Import Successful')
    end
  end

  def cleanup
    upload.sample_file.purge
    upload.destroy!
  end

  def update_message(new_message)
    Turbo::StreamsChannel.broadcast_update_to(
      upload,
      target: "current-step",
      html: new_message
    )
  end

  def add_step(message, status = :success)
    Turbo::StreamsChannel.broadcast_append_to(
      upload,
      target: "step-list",
      partial: 'uploads/step',
      locals: {status: status, message: message}
    )
  end

  def any_errors?
    errors.any? && errors.values.any? { |e| e.any? }
  end
end
