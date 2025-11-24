require 'csv'

module TableDownloader
  extend ActiveSupport::Concern

  included do
    before_action :set_tsv_path
  end

  def set_tsv_path
    @tsv_path = "#{request.path}/#{request.params[:display]}.tsv?#{params.permit(q: {}).to_query}"
  end

  def stream_table(results:, filename:, formatter:)
    headers.delete('Content-Length')
    headers['Cache-Control'] = 'no-cache'
    headers['Content-Type'] = 'text/tab-separated-values'
    headers['Content-Disposition'] = "attachment; filename=\"#{filename}-#{Date.today}.tsv\""
    headers['X-Accel-Buffering'] = 'no'

    response.status = 200

    self.response_body = Enumerator.new do |collection|
      collection << CSV.generate_line(formatter.headers, col_sep: "\t")
      results.find_each do |result|
        collection << CSV.generate_line(formatter.to_row(result), col_sep: "\t")
      end
    end
  end
end
