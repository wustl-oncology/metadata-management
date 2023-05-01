class ProjectsController < ApplicationController
  def index
    @q = Project.ransack(params[:q])

    scope = @q.result(distinct: true).includes(:tags).select(:id, :name, :lab)

    @pagy, @projects = pagy(
      scope,
      link_extra: 'data-turbo-frame="projects_table" data-turbo-action="advance"'
    )
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
  end

  def create
  end

  def update
  end
end
