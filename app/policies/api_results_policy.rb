class ApiResultsPolicy < ApplicationPolicy
  def create?
    LabMembership.where(user: user, permissions: 'write', lab_id: record.lab_id).exists?
  end
end
