class SamplesController < ApplicationController
  include RansackQueries

  def index
    ransack_samples
  end
end
