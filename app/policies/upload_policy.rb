class UploadPolicy < ApplicationPolicy
  def new?
    LabMembership.where(user: user, permissions: 'write', lab_id: record.lab_id).exists?
  end

  def create?
    new?
  end

  def show?
    true
  end
end
