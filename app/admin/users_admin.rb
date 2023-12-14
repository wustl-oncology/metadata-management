Trestle.resource(:users) do
  remove_action :edit, :new

  menu do
    item :users, icon: "fa fa-star"
  end

  table do
    column :id
    column :name
    column :email
    actions
  end
end
