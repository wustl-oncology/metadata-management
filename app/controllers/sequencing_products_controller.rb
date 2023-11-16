class SequencingProductsController < ApplicationController
  include RansackQueries
  include TableDownloader

  before_action :set_sequencing_product, only: [:show]

  def index
    ransack_sequence_products
    respond_to do |format|
      format.html
      format.turbo_stream
      format.tsv { stream_table(results: @scope, filename: 'sequence-products', formatter: TsvFormatters::SequencingProduct.new)  }
    end
  end

  def show
    setup_table_queries
    @attrs = [
      ['Sample', helpers.link_to(@sp.sample.name, helpers.sample_path(@sp.sample), data: {turbo_frame: :_top})],
      ['Library Prep', @sp.library_prep],
      ['Flow Cell ID', @sp.flow_cell_id],
      ['Unaligned Data Path', @sp.unaligned_data_path],
      ['Strand', @sp.strand],
      ['Kit', @sp.kit],
      ['Targeted Capture', @sp.targeted_capture],
      ['Paired End', @sp.paired_end],
      ['Batch', @sp.batch],
    ]
  end

  private
  def set_sequencing_product
    @sp = SequencingProduct.includes(:tags,:sample).find(params.permit(:id)[:id])
  end

  def setup_table_queries
    @table_name = if params[:display] == 'pipeline_outputs'
                    q = PipelineOutput
                      .joins(:sequencing_products)
                      .where(sequencing_products: { id:  @sp.id })
                      .ransack(params[:q])
                    ransack_pipeline_outputs(base_query: q)
                    'sequencing_products/sequencing_products_pipeline_outputs'
                  else
                    q = Project.joins(:samples)
                      .where(samples: { id: @sp.id  })
                      .ransack(params[:q])
                    ransack_projects(base_query: q)
                    'sequencing_products/sequencing_products_projects'
                  end
  end
end
