module TsvFormatters
  class PipelineOutput
    def headers
      [
        'id', 
        'platform',
        'pipeline',
        'pipeline_version',
        'platform_id',
        'data_location',
        'sequence_products',
        'notes',
        'tags'
      ]
    end

    def to_row(po)
      [
        po.id,
        po.platform,
        po.pipeline_name,
        po.pipeline_version,
        po.platform_identifier,
        po.data_location,
        po.sequencing_products.map(&:unaligned_data_path).join(', '),
        po.notes,
        po.tags.map(&:tag).join(',')
      ]
    end
  end
end
