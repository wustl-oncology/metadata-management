class SamplesController < ApplicationController

  def index
    @q = Sample.ransack(params[:q])

    scope = @q.result(distinct: true).includes(:tags).select(
      :id,
      :name,
      :species,
      :disease_status,
      :individual,
      :timepoint,
    )

    @pagy, @samples = pagy(
      scope,
      link_extra: 'data-turbo-frame="projects_table" data-turbo-action="advance"'
    )
  end
end
