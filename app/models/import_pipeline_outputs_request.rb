require 'json-schema'

class ImportPipelineOutputsRequest
  attr_reader :errors, :project

  def initialize(request, user)
    @request = request
    @user = user
    @errors = nil
    @attrs = request.deep_transform_keys { |k| k.to_s.underscore }
  end

  def valid?
    if errors.nil?
      @errors = []
      validate_json
      validate_identifiers
    end

    if errors.any?
      false
    else
      true
    end
  end

  def import
    raise StandardError.new("Cannot import invalid data") unless valid?

    ActiveRecord::Base.transaction do
      values = attrs.merge({user_id: user.id})
      tags = values.delete('tags')
      note = values.delete('note')

      po = PipelineOutput.where(values).first_or_create!
      po.sequencing_products = (sequence_products + po.sequencing_products).uniq
      if note
        po.notes = note
      end
      if tags&.any?
        po.tag!(*tags)
      end
      po.save!
    rescue StandardError => e
      errors << e.message
      raise ActiveRecord::Rollback
    end
    return errors.none?
  end

  private 
  def validate_json
    @errors += JSON::Validator.fully_validate(SCHEMA, request)
  end

  def validate_identifiers
    if attrs['project_name']
      name = attrs.delete('project_name')
      p = Project.find_by(name: name&.strip)
      if p
        attrs['project_id'] = p.id
        @project = p
      else
        @errors << "Project with name #{name} not found."
      end
    else
      p = Project.find_by(id: attrs['project_id'])
      if p
        @project = p
      else
        @errors << "Project with ID #{attrs['project_id']} not found."
      end
    end

    sequence_product_paths = attrs.delete('input_paths')
    @sequence_products = SequencingProduct.where(unaligned_data_path: sequence_product_paths).includes(:sample)

    if sequence_products.size != sequence_product_paths.size
      @errors << "Specified Sequence Product paths #{sequence_product_paths.join(", ")} but only #{products.map(&:unaligned_data_path).join(", ")} found."
    end

    sequence_products.each do |sp|
      unless sp.sample.project_ids.include?(attrs['project_id'])
        @errors << "Sequence Product #{sp.unaligned_data_path} is not a member of Project #{attrs['project_id']}"
      end
    end
  end


  attr_reader :request, :user, :sequence_products, :attrs

  SCHEMA = {
    type: 'object',
    properties: {
      pipelineName: {
        type: 'string'
      },
      pipelineVersion: {
        type: 'string'
      },
      platform: {
        type: 'string'
      },
      platformIdentifier: {
        type: 'string'
      },
      dataLocation: {
        type: 'string'
      },
      notes: {
        type: 'string'
      },
      tags: {
        type: 'array',
        items: {
          type: 'string'
        },
        minItems: 1,
        uniqueItems: true
      },
      inputPaths: {
        type: 'array',
        items: {
          type: 'string'
        },
        minItems: 1,
        uniqueItems: true
      }
    },
    required: [
      'pipelineName',
      'pipelineVersion',
      'platform',
      'platformIdentifier',
      'inputPaths',
      'dataLocation'
    ],
    oneOf: [
      properties: {
        projectId: {
          type: 'integer'
        },
        required: [ 'projectId' ]
      },
      properties: {
        projectName: {
          type: 'string'
        },
        required: [ 'projectName' ]
      }
    ]
  }
end

#{
  #project_id: 2, #req
  #pipeline_name: String, #req
  #pipeline_version: String, #req
  #platform: String, #req
  #platform_identifier: String, #req
  #input_paths: [String], #req
  #data_path: String, #req
  #run_completed_at: DateTime #op
#}
