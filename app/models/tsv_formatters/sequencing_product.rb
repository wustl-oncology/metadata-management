module TsvFormatters
  class SequencingProduct
    def headers
      [
        'id', 
        'sample',
        'library_prep',
        'flow_cell_id',
        'instrument',
        'unaligned_data_path',
        'notes',
        'tags'
      ]
    end

    def to_row(sp)
      [
        sp.id,
        sp.sample.name,
        sp.library_prep,
        sp.flow_cell_id,
        sp.instrument,
        sp.unaligned_data_path,
        sp.notes,
        sp.tags.map(&:tag).join(',')
      ]
    end
  end
end
