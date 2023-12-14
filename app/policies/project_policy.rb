class ProjectPolicy < ApplicationPolicy
  def new?
    LabMembership.where(user: user, permissions: 'write').exists?
  end

  def create?
    LabMembership.where(user: user, permissions: 'write', lab_id: record.lab_id).exists?
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def show?
    true
  end

  def index?
    true
  end
end
