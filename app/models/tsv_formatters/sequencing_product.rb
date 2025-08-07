module TsvFormatters
  class SequencingProduct
    def headers
      %w[
        id
        sample
        library_prep
        flow_cell_id
        instrument
        unaligned_data_path
        strand
        kit
        targeted_capture
        paired_end
        batch
        read_length
        notes
        tags
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
        sp.strand,
        sp.kit,
        sp.targeted_capture,
        sp.paired_end,
        sp.read_length,
        sp.notes,
        sp.tags.map(&:tag).join(',')
      ]
    end
  end
end
