class RemovePosFromPhotos < ActiveRecord::Migration[5.1]
  def change
    remove_column :photos, :camera_model, :string
    remove_column :photos, :width, :integer
    remove_column :photos, :height, :integer
    remove_column :photos, :focal_length, :decimal
  end
end
