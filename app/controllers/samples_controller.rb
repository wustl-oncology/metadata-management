class SamplesController < ApplicationController
  include RansackQueries
  include TableDownloader

  before_action :set_sample, only: [:show]

  def index
    if (project_id = params.dig(:q, :project_id))
      ransack_samples(base_query: Sample.joins(:projects).where(projects: { id: project_id }))
    else
      ransack_samples
    end
    respond_to do |format|
      format.html
      format.turbo_stream
      format.tsv { stream_table(results: @scope, filename: 'samples', formatter: TsvFormatters::Sample.new)  }
    end
  end

  def show
    setup_table_queries
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

  def setup_table_queries
    @table_name = if params[:display] == 'sequencing_products'
                    q = SequencingProduct
                      .where(sample_id: @sample.id)
                    ransack_sequence_products(base_query: q)
                    'samples/sample_sequencing_products'
                  elsif params[:display] == 'pipeline_outputs'
                    q = PipelineOutput
                        .joins(sequencing_products: [:sample])
                        .where(sequencing_products: { samples: { id:  @sample.id }})
                    ransack_pipeline_outputs(base_query: q)
                    'samples/sample_pipeline_outputs'
                  else
                    q = Project.joins(:samples)
                      .where(samples: { id: @sample.id  })
                    ransack_projects(base_query: q)
                    'samples/sample_projects'
                  end
  end
end
