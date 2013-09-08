class AddVideoConvertedToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :video_converted, :string
  end
end
