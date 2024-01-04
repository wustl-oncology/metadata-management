class ProjectPolicy < ApplicationPolicy
  def self.authorized_projects(user:, mode: :read)
    authorized_labs = if mode == :read
                       user.lab_memberships
                     else
                       user.writable_lab_memberships
                     end

    Project.where(lab_id: authorized_labs.select(:lab_id))
  end

  class Scope < Scope
    def resolve
      scope.where(id: ProjectPolicy.authorized_projects(user: user).select(:id))
    end
  end

  def new?
    LabMembership.where(user: user, permissions: 'write').exists?
  end

  def create?
    user.writable_lab_memberships.where(lab_id: record.lab_id).exists?
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def show?
    user.lab_memberships.where(lab_id: record.lab_id).exists?
  end
end
