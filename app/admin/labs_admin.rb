Trestle.resource(:labs) do
  menu do
    item :labs, icon: "fa fa-star", priority: :first
  end

  table do
    column :id
    column :name
    actions
  end

  form do |lab|
    col(sm: 2) { static_field :id }
    col(sm: 8) { text_field :name }
  end
end
