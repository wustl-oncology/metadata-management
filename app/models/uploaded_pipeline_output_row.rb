class UploadedPipelineOutputRow
  attr_reader :row, :errors, :project, :sample, :sequencing_product, :user

  def self.expected_headers
    [
      "Pipeline Name",
      "Pipeline Version",
      "Platform",
      "Platform Identifier",
      "Data Location",
      "Input Paths",
    ]
  end

  def initialize(row, project, user)
    @row = row
    @errors = []
    @created_entities = []
    @project = project
    @user = user
  end

  def valid?
    errors.none?
  end

  def persist_row
    validate_required_values unless errors.any?
    create_pipeline_output unless errors.any?
  end

  private
  def validate_required_values
    #TODO - not all fields will be required
    #self.class.expected_headers.each do |header|
      #if row[header].blank?
        #errors << "Required field missing: #{header}"
      #end
    #end
  end

  def create_pipeline_output
    paths = row["Input Paths"].split(",")
    inputs = SequencingProduct.where(unaligned_data_path: row['Input Paths'])
    if inputs.size != paths.size
      errors << "Expected to find #{paths.size} inputs but found #{inputs.size}"
    end

    if PipelineOutput.find_by(data_location: row['Data Location']).present?
      errors << "Result already exists at #{row['Data Location']}"
    end

    po = PipelineOutput.from_upload_row(row)
    po.user = user
    po.project = project
    po.sequencing_products = inputs
    po.save!
  end
end
