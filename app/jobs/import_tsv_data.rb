require 'csv'
class ImportTsvData < ApplicationJob
  attr_reader :upload, :errors, :row_validator_type

  def perform(upload, row_validator_type, user)
    @errors = Hash.new { |h, k| h[k] = [] }
    @upload = upload
    @row_validator_type = row_validator_type
    first_row = true

    add_step('Checking File')
    ActiveRecord::Base.transaction do
      upload.sample_file.open do |file|
        CSV.foreach(file, col_sep: "\t", headers: true, row_sep: :auto).with_index do |row, i|
          if first_row
            break unless validate_headers(row.headers, row_validator_type.expected_headers)

            first_row = false
          end
          row_validator = row_validator_type.new(row, upload.project, user)
          row_validator.persist_row
          errors["row_#{i + 1}"] = row_validator.errors if row_validator.errors.any?
        end
      end

      raise ActiveRecord::Rollback if any_errors?
    end
  rescue StandardError => e
    errors[:general] << e.message
  ensure
    convey_result
    cleanup
  end

  private

  def validate_headers(headers, expected_headers)
    update_message('Validating Headers..')

    if headers != expected_headers
      missing_headers = expected_headers - headers
      errors[:headers] << "Expected to find #{missing_headers.join(', ')} headers but did not." if missing_headers.any?
      extra_headers = headers - expected_headers
      errors[:headers] << "Found unexpected headers: #{extra_headers.join(', ')}." if extra_headers.any?
    end

    if errors[:headers].none?
      update_message('Validating Rows..')
      add_step('Headers Validated')
      true
    else
      add_step('Invalid Headers Detected', :error)
      false
    end
  end

  def convey_result
    binding.irb unless Rails.env.production?
    if any_errors?
      Turbo::StreamsChannel.broadcast_update_to(
        upload,
        target: 'import-result',
        partial: 'uploads/error-result',
        locals: { errors: errors, project: upload.project, upload_type: row_validator_type.upload_type }
      )
      update_message('Import Failed')
    else
      Turbo::StreamsChannel.broadcast_update_to(
        upload,
        target: 'import-result',
        partial: 'uploads/success-result',
        locals: { project: upload.project }
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
      target: 'current-step',
      html: new_message
    )
  end

  def add_step(message, status = :success)
    Turbo::StreamsChannel.broadcast_append_to(
      upload,
      target: 'step-list',
      partial: 'uploads/step',
      locals: { status: status, message: message }
    )
  end

  def any_errors?
    errors.any? && errors.values.any? { |e| e.any? }
  end
end
