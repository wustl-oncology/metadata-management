module TsvFormatters
  class Project
    def headers
      ['id', 'name', 'lab', 'notes', 'tags']
    end

    def to_row(project)
      [
        project.id,
        project.name,
        project.lab,
        project.notes,
        project.tags.map(&:tag).join(',')
      ]
    end
  end
end
