Trestle.resource(:lab_memberships) do
  menu do
    item :lab_memberships, icon: "fa fa-star"
  end

  collection do
    LabMembership.eager_load(:user, :lab)
  end

  table do
    column :user do |lm|
      lm.user.name
    end
    column :lab do |lm|
      lm.lab.name
    end
    column :permissions
    actions
  end

  form do |lm|
    select :user_id, User.all
    select :lab_id, Lab.all
    select :permissions, LabMembership.permissions.keys, default: 'read'
  end
end
