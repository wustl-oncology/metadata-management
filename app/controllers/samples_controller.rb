class SamplesController < ApplicationController
  include RansackQueries
  include TableDownloader

  before_action :set_sample, only: [:show]

  def index
    ransack_samples(project_id: params.dig(:q,:project_id))
    respond_to do |format|
      format.html
      format.turbo_stream
      format.tsv { stream_table(results: @scope, filename: 'samples', formatter: TsvFormatters::Sample.new)  }
    end
  end

  def show
    @attrs = [
      ['Species', @sample.species],
      ['Disease Status', @sample.disease_status],
      ['Individual', @sample.individual],
      ['Timepoint', @sample.timepoint],
    ]
  end

  private
  def set_sample
    @sample = Sample.includes(:tags).find(params.permit(:id)[:id])
  end
end
