class SamplesController < ApplicationController
  include RansackQueries
  include TableDownloader

  before_action :set_sample, only: [:show, :edit, :update]

  def index
    base_query = if (project_id = params.dig(:q, :project_id))
                   Sample.joins(:projects)
                     .where(projects: { id: project_id })
                 else
                   Sample
                 end

    ransack_samples(base_query: policy_scope(base_query))

    respond_to do |format|
      format.html
      format.turbo_stream
      format.tsv { stream_table(results: @scope, filename: 'samples', formatter: TsvFormatters::Sample.new)  }
    end
  end

  def show
    authorize @sample
    setup_table_queries
    @attrs = [
      ['Species', @sample.species],
      ['Disease Status', @sample.disease_status],
      ['Individual', @sample.individual],
      ['Timepoint', @sample.timepoint],
    ]
  end

  def edit
    authorize @sample
  end

  def update
    authorize @sample

    if @sample.update(sample_params)
      redirect_to @sample
    else
      render :edit
    end
  end

  private
  def sample_params
    params.require(:sample).permit(
      :name,
      :species,
      :individual,
      :timepoint,
      :disease_status,
      :notes
    )
  end

  def set_sample
    @sample = Sample.includes(:tags).find(params.permit(:id)[:id])
  end

  def setup_table_queries
    display_mode = params.permit(:display)[:display]
    @table_name = if display_mode == 'sequencing_products'
                    q = SequencingProduct
                      .where(sample_id: @sample.id)
                    ransack_sequence_products(base_query: policy_scope(q))
                    'samples/sample_sequencing_products'
                  elsif display_mode == 'pipeline_outputs'
                    q = PipelineOutput
                        .joins(sequencing_products: [:sample])
                        .where(sequencing_products: { samples: { id:  @sample.id }})
                    ransack_pipeline_outputs(base_query: policy_scope(q))
                    'samples/sample_pipeline_outputs'
                  else
                    q = Project.joins(:samples)
                      .where(samples: { id: @sample.id  })
                    ransack_projects(base_query: policy_scope(q))
                    'samples/sample_projects'
                  end
  end
end
