class AddProcessingMetadataToVideos < ActiveRecord::Migration[7.2]
  def change
    add_column :videos, :processing_metadata, :jsonb
  end
end
