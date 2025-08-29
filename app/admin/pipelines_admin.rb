# frozen_string_literal: true

Trestle.resource(:pipelines) do
  menu do
    item :pipelines, icon: 'fa fa-list', after: :labs
  end

  table do
    column :name
    column :platform
    actions
  end

  form do |_pipeline|
    text_field :name
    select :platform, PlatformConstraints::PLATFORMS
  end
end
