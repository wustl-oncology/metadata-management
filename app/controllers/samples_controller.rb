class SamplesController < ApplicationController
  include RansackQueries
  include TableDownloader

  def index
    ransack_samples
    respond_to do |format|
      format.html
      format.turbo_stream
      format.tsv { stream_table(results: @scope, filename: 'samples', formatter: TsvFormatters::Sample.new)  }
    end
  end
end
