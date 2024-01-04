class PipelineOutputsController < ApplicationController
  include RansackQueries
  include TableDownloader

  before_action :set_pipeline_output, only: [:show]

  def index
    base_query = if (project_id = params.dig(:q, :project_id))
                   PipelineOutput.where(project_id: project_id)
                 else
                   PipelineOutput
                 end

    ransack_pipeline_outputs(base_query: policy_scope(base_query))

    respond_to do |format|
      format.html
      format.turbo_stream
      format.tsv { stream_table(results: @scope, filename: 'pipeline-outputs', formatter: TsvFormatters::PipelineOutput.new)  }
    end
  end

  def show
    authorize @po
    setup_table_queries
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

  def setup_table_queries
    @table_name = if params[:display] == 'sequencing_products'
                    q = SequencingProduct
                      .joins(:pipeline_outputs)
                      .where(pipeline_outputs: { id: @po.id })
                    ransack_sequence_products(base_query: policy_scope(q))
                    'pipeline_outputs/pipeline_outputs_sequencing_products'
                  else
                    q = Sample.joins(sequencing_products: [:pipeline_outputs])
                      .where(sequencing_products: { pipeline_outputs: { id: @po.id  }})
                    ransack_samples(base_query: policy_scope(q))
                    'pipeline_outputs/pipeline_outputs_samples'
                  end
  end
end
