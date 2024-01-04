class PipelineOutputPolicy < ApplicationPolicy
  def self.authorized_pipeline_outputs(user:, mode: :read)
    authorized_projects = ProjectPolicy.authorized_projects(user: user, mode: mode)

    PipelineOutput.where(project_id: authorized_projects.select(:id))
  end

  class Scope < Scope
    def resolve
      scope.where(id: PipelineOutputPolicy.authorized_pipeline_outputs(user: user).select(:id))
    end
  end

  def show?
    PipelineOutputPolicy.authorized_pipeline_outputs(user: user)
      .where(id: record.id)
      .exists?
  end

  def edit?
    PipelineOutputPolicy.authorized_pipeline_outputs(user: user, mode: :write)
      .where(id: record.id)
      .exists?
  end

  def update?
    edit?
  end

  def create?
    raise NotImplementedError.new("create? policy not implemented")
  end
end
