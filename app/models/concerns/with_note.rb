module WithNote
  extend ActiveSupport::Concern

  included do
    def formatted_notes
      if self.notes.present?
        Rails.cache.fetch(note_cache_key) do 
          Kramdown::Document.new(self.notes).to_html
        end
      else
        nil
      end
    end

    def note_cache_key
      "#{self.class}:#{self.id}:note:#{self.updated_at}"
    end
  end
end
