class PipelineOutputsController < ApplicationController
  include RansackQueries
  include TableDownloader

  def index
    ransack_pipeline_outputs(project_id: params.dig(:q,:project_id))

    respond_to do |format|
      format.html
      format.turbo_stream
      format.tsv { stream_table(results: @scope, filename: 'pipeline-outputs', formatter: TsvFormatters::PipelineOutput.new)  }
    end
  end
end
