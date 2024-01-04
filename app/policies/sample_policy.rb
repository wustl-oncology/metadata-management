class SamplePolicy < ApplicationPolicy
  def self.authorized_samples(user:, mode: :read)
    authorized_projects = ProjectPolicy.authorized_projects(user: user, mode: mode)

    ProjectsSample.where(project_id: authorized_projects.select(:id))
  end

  class Scope < Scope
    def resolve
      scope.where(id: SamplePolicy.authorized_samples(user: user).select(:sample_id))
    end
  end

  def show?
    SamplePolicy.authorized_samples(user: user)
      .where(sample_id: record.id).exists?
  end

  def edit?
    SamplePolicy.authorized_samples(user: user, mode: :write)
      .where(sample_id: record.id).exists?
  end

  def update?
    edit?
  end

  def create?
    raise NotImplementedError.new("create? policy not implemented")
  end
end
