class SequencingProductsController < ApplicationController
  include RansackQueries
  include TableDownloader

  before_action :set_sequencing_product, only: %i[show edit update]

  def index
    base_query = if (project_id = params.dig(:q, :project_id))
                   SequencingProduct.joins(sample: [:projects])
                                    .where(projects: { id: project_id })
                 else
                   SequencingProduct end

    ransack_sequence_products(base_query: policy_scope(base_query))

    respond_to do |format|
      format.html
      format.turbo_stream
      format.tsv { stream_table(results: @scope, filename: 'sequence-products', formatter: TsvFormatters::SequencingProduct.new) }
    end
  end

  def show
    authorize @sp
    setup_table_queries
    @attrs = [
      ['Sample', helpers.link_to(@sp.sample.name, helpers.sample_path(@sp.sample), data: { turbo_frame: :_top })],
      ['Library Prep', @sp.library_prep],
      ['Flow Cell ID', @sp.flow_cell_id],
      ['Unaligned Data Path', @sp.unaligned_data_path],
      ['Strand', @sp.strand],
      ['Kit', @sp.kit],
      ['Targeted Capture', @sp.targeted_capture],
      ['Paired End', @sp.paired_end],
      ['Batch', @sp.batch],
      ['Read Length', @sp.read_length]
    ]
  end

  def edit
    authorize @sp
  end

  def update
    authorize @sp

    if @sp.update(sp_params)
      redirect_to @sp
    else
      render :edit
    end
  end

  private

  def sp_params
    params.require(:sequencing_product).permit(
      :library_prep,
      :flow_cell_id,
      :unaligned_data_path,
      :strand,
      :kit,
      :targeted_capture,
      :paired_end,
      :batch,
      :notes
    )
  end

  def set_sequencing_product
    @sp = SequencingProduct.includes(:tags, :sample).find(params.permit(:id)[:id])
  end

  def setup_table_queries
    @table_name = if params.permit(:display)[:display] == 'pipeline_outputs'
                    q = PipelineOutput
                        .joins(:sequencing_products)
                        .where(sequencing_products: { id: @sp.id })
                    ransack_pipeline_outputs(base_query: policy_scope(q))
                    'sequencing_products/sequencing_products_pipeline_outputs'
                  else
                    q = Project.joins(:samples)
                               .where(samples: { id: @sp.sample_id })
                    ransack_projects(base_query: policy_scope(q))
                    'sequencing_products/sequencing_products_projects'
                  end
  end
end
