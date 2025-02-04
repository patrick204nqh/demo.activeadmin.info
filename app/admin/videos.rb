ActiveAdmin.register Video do
  menu parent: "Media"

  # Specify parameters which should be permitted for assignment
  permit_params :title, :file

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :title
  filter :status
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :title
    column :status
    column "Original File" do |video|
      # link_to(video.file.filename.to_s, rails_blob_path(video.file, disposition: "attachment")) if video.file.attached?
      video_tag(video.file.url(expires_in: 1.hour), controls: true, controls: true, width: "400") if video.file.attached?
    end
    column "Processed File" do |video|
      # link_to("Download", rails_blob_path(video.processed_file, disposition: "attachment")) if video.processed_file.attached?
      video_tag(video.processed_file.url(expires_in: 1.hour), controls: true, controls: true, width: "400") if video.processed_file.attached?
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
      row :status
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :title
      f.input :file, as: :file
    end
    f.actions
  end

  # member_action :retry, method: :post do
  #   video = Video.find(params[:id])
  #   if video.failed?
  #     video.process! # Transition back to processing
  #     ProcessVideoJob.perform_later(video.id)
  #     redirect_to admin_video_path(video), notice: "Video re-enqueued for processing."
  #   else
  #     redirect_to admin_video_path(video), alert: "Retry is only allowed for failed videos."
  #   end
  # end

  # action_item :retry, only: :show, if: proc { video.failed? } do
  #   link_to "Retry Processing", retry_admin_video_path(video), method: :post
  # end
end
