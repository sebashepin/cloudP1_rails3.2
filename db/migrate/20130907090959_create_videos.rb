class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do|t|
        t.belongs_to :user
        t.string :name
        t.string :path
        t.integer :estado
        t.string :video

        t.timestamps
    end
  end
end
