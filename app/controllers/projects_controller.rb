class ProjectsController < ApplicationController
  include RansackQueries

  before_action :set_project, only: [:show, :edit, :update]

  def index
    @q = Project.ransack(params[:q])

    scope = @q.result(distinct: true).includes(:tags).select(:id, :name, :lab)

    @pagy, @projects = pagy(
      scope,
      link_extra: 'data-turbo-frame="projects_table" data-turbo-action="advance"'
    )
  end

  def show
    setup_table_queries
  end

  def edit
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project
    else
      render :new
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project
    else
      render :edit
    end
  end

  private
  def project_params
    params.require(:project).permit(:name, :lab, :notes)
  end

  def set_project
    @project = Project.includes(:tags).find(params[:id])
  end

  def setup_table_queries
    @table_name = if params[:display] == 'sequencing_products'
                    ransack_sequence_products(project_id: @project.id)
                    'projects/project_sequencing_products'
                  else
                    ransack_samples(project_id: @project.id)
                    'projects/project_samples'
                  end
  end
end
