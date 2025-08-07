module TsvFormatters
  class Sample
    def headers
      %w[
        id
        name
        species
        disease_status
        individual
        timepoint
        read_length
        notes
        tags
      ]
    end

    def to_row(s)
      [
        s.id,
        s.name,
        s.species,
        s.disease_status,
        s.individual,
        s.timepoint,
        s.read_length,
        s.notes,
        s.tags.map(&:tag).join(',')
      ]
    end
  end
end
