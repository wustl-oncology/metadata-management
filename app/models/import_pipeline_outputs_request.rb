require 'json-schema'

class ImportPipelineOutputsRequest
  attr_reader :errors

  def initialize(request, user)
    @request = request
    @user = user
    @errors = nil
  end

  def valid?
    if errors.nil?
      validate
    end

    if errors.any?
      false
    else
      true
    end
  end

  def import
    #raise StandardError.new("Cannot import invalid data") unless valid?
    #attrs = request.deep_transform_keys { |k| k.to_s.underscore }
    #samples = attrs.delete('sample_names')
    #ActiveRecord::Base.transaction do
      #samples.each do |s|
        #sp = SequencingProduct.find_by!(sample_id: s)
        #values = attrs.merge({user_id: user.id})
        #po = PipelineOutput.where(values).first_or_create!
        #po.samples << sp unless po.samples.includes?(sp)
      #end
    #rescue StandardError => e
      #errors << e.message
      #raise ActiveRecord::Rollback
    #end
    true
  end

  private 
  def validate
    @errors = JSON::Validator.fully_validate(SCHEMA, request)
  end


  attr_reader :request, :user

  SCHEMA = {
    type: 'object',
    properties: {
      projectId: {
        type: 'integer'
      },
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
      dataPath: {
        type: 'string'
      },
      sampleNames: {
        type: 'array',
        items: {
          type: 'string'
        },
        minItems: 1,
        uniqueItems: true
      }
    },
    required: [
      'projectId',
      'pipelineName',
      'pipelineVersion',
      'platform',
      'platformIdentifier',
      'sampleNames',
      'dataPath'
    ]
  }
end

#{
  #project_id: 2, #req
  #pipeline_name: String, #req
  #pipeline_version: String, #req
  #platform: String, #req
  #platform_identifier: String, #req
  #sample_names: [String], #req
  #data_path: String, #req
  #run_completed_at: DateTime #op
#}
