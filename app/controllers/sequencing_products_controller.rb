class SequencingProductsController < ApplicationController
  include RansackQueries
  include TableDownloader

  def index
    ransack_sequence_products(project_id: params.dig(:q,:project_id))
    respond_to do |format|
      format.html
      format.turbo_stream
      format.tsv { stream_table(results: @scope, filename: 'sequence-products', formatter: TsvFormatters::SequencingProduct.new)  }
    end
  end
end
