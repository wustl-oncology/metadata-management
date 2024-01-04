class SequencingProductPolicy < ApplicationPolicy
  def self.authorized_sequencing_products(user:, mode: :read)
    authorized_projects = ProjectPolicy.authorized_projects(user: user, mode: mode)

    SequencingProduct.joins(sample: [:projects])
      .where(projects: { id: authorized_projects.select(:id) })
      .distinct
  end

  class Scope < Scope
    def resolve
      scope.where(id: SequencingProductPolicy.authorized_sequencing_products(user: user).select(:id))
    end
  end

  def show?
    SequencingProductPolicy.authorized_sequencing_products(user: user)
      .where(id: record.id)
      .exists?
  end

  def edit?
    SequencingProductPolicy.authorized_sequencing_products(user: user, mode: :write)
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
