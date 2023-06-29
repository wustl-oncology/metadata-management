class SequencingProductsController < ApplicationController
  include RansackQueries

  def index
    ransack_sequence_products
  end
end
