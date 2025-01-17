ActiveAdmin.register Post do
  decorate_with PostDecorator
  menu label: "Articles", parent: "Blog"

  # Specify parameters which should be permitted for assignment
  permit_params :title, :content, :category_id, :image

  # Enable comments
  config.comments = true

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :title
  filter :content
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :title
    column :content
    column :image do |post|
      post.display_image(size: :small)
    end
    column :category do |post|
      post.category.name
    end
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :title
      row :content
      row :image do |post|
        post.display_image(size: :medium)
      end
      row :category do |post|
        post.category.name
      end
      row :created_at
      row :updated_at
    end

    active_admin_comments_for(resource)
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs "Post Details" do
      f.input :title
      f.input :content
      f.input :image, as: :file
      f.input :category, as: :select, collection: Category.all.collect { |c| [c.name, c.id] }
    end
    f.actions
  end
end
