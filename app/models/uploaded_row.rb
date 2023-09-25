class UploadedRow
  attr_reader :row, :errors, :project, :sample, :sequencing_product
  def initialize(row, project)
    @row = row
    @errors = []
    @created_entities = []
    @project = project
  end

  def valid?
    errors.none?
  end

  def persist_row
    validate_required_values unless errors.any?
    create_sample unless errors.any?
    create_sequencing_product unless errors.any?
  end

  private
  def validate_required_values
    #TODO - not all fields will be required
    #Upload.expected_headers.each do |header|
      #if row[header].blank?
        #errors << "Required field missing: #{header}"
      #end
    #end
  end

  def create_sample
    existing_sample = Sample.find_by(name: row['Sample Name'].strip)
    proposed_sample = Sample.from_upload_row(row)
    
    if existing_sample
      [:species, :individual, :timepoint, :disease_status].each do |field|
        if existing_sample.send(field) != proposed_sample.send(field)
          errors << "#{field.to_s.humanize} value for sample #{existing_sample.name} conflicts with existing sample."
        end
      end

      if errors.none?
        @sample = existing_sample
        unless existing_sample.projects.exists?(project.id)
          existing_sample.projects << project
        end
      end
    else
      unless proposed_sample.projects.exists?(project.id)
        proposed_sample.projects << project
      end
      proposed_sample.save!
      @sample = proposed_sample
    end
  end

  def create_sequencing_product
    existing_product = SequencingProduct.find_by(unaligned_data_path: row['Unaligned Data Path'])
    proposed_product = SequencingProduct.from_upload_row(row)

    if existing_product
      [:library_prep, :instrument, :flow_cell_id, :strand, :kit, :targeted_capture, :paired_end, :batch].each do |field|
        if existing_product.send(field) != proposed_product.send(field)
          errors << "#{field.to_s_humanize} value for sequencing product #{existing_product.unaligned_data_path} conflicts with existing data."
        end
        
        if existing_product.sample != sample
          errors << "Sequencing product #{existing_product.unaligned_data_path} is already associated with Sample #{existing_product.sample.name}"
        end

        if errors.none?
          @sequencing_product = existing_product
        end
      end
    else
      proposed_product.sample = sample
      proposed_product.save!
      @sequencing_product = proposed_product
    end
  end
end
