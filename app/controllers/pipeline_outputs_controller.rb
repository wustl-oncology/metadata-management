class PipelineOutputsController < ApplicationController
  include RansackQueries
  include TableDownloader

  before_action :set_pipeline_output, only: [:show]

  def index
    ransack_pipeline_outputs

    respond_to do |format|
      format.html
      format.turbo_stream
      format.tsv { stream_table(results: @scope, filename: 'pipeline-outputs', formatter: TsvFormatters::PipelineOutput.new)  }
    end
  end

  def show
    @attrs = [
      ['Pipeline Name', @po.pipeline_name],
      ['Pipeline Version', @po.pipeline_version],
      ['Platform', @po.platform],
      ['Platform Identifier', @po.platform_identifier],
      ['Data Location', @po.data_location],
      ['Created By', @po.user.name],
      ['Project', helpers.link_to(@po.project.name, helpers.project_path(@po.project))],
    ]
  end

  private
  def set_pipeline_output
    @po = PipelineOutput.includes(:tags, :user, :project)
      .find(params.permit(:id)[:id])
  end
end
