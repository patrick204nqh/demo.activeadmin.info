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
    column "Thumbnail" do |video|
      if video.thumbnail.attached?
        image_tag(video.thumbnail.url, width: "100")
      else
        "No Thumbnail Available"
      end
    end
    # column "Original File" do |video|
      # link_to(video.file.filename.to_s, rails_blob_path(video.file, disposition: "attachment")) if video.file.attached?
    #   video_tag(video.file.url(expires_in: 1.hour), controls: true, width: "400") if video.file.attached?
    # end
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
      row :processing_metadata do |video|
        details do
          summary "View Full Metadata"
          div do
            pre JSON.pretty_generate(video.processing_metadata || {})
          end
        end
      end
      row :created_at
      row :updated_at

      row "Original Video" do |video|
        if video.file.attached?
          video_tag(video.file.url(expires_in: 1.hour), controls: true, width: "400")
        else
          "No Original Video Available"
        end
      end

      ["360p", "720p", "1080p"].each do |resolution|
        row "#{resolution} Video" do |video|
          processed_video = video.send("video_#{resolution}")
          if processed_video.attached?
            video_tag(processed_video.url(expires_in: 1.hour), controls: true, width: "400")
          else
            "Processing not completed"
          end
        end
      end
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

  member_action :retry, method: :post do
    video = Video.find(params[:id])

    if video.failed?
      video.process! # Transition back to processing
      ProcessVideoJob.perform_later(video.id)
      redirect_to admin_video_path(video), notice: "Video re-enqueued for processing."
    else
      redirect_to admin_video_path(video), alert: "Retry is only allowed for failed videos."
    end
  end

  action_item :retry, only: :show, if: proc { resource.failed? } do
    link_to "Retry Processing", retry_admin_video_path(resource), method: :post
  end
end
