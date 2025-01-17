ActiveAdmin.register Category do
  menu parent: "Blog"

  permit_params :name

  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :name
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :name
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :name
      row :created_at
      row :updated_at
    end

    panel "Articles" do
      table_for category.posts do
        column :id
        column :title
        column :content
        column :created_at
        column :updated_at
      end
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
