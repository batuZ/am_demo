class AddSomeToGroups < ActiveRecord::Migration[5.1]
  def change
     add_column :groups, :focal_length, :decimal, precision: 5, scale: 2
    add_column :groups, :camera_model, :string
    add_column :groups, :width, :integer
    add_column :groups, :height, :integer
    add_column :groups, :ccd_width, :decimal, precision: 5, scale: 3
    add_column :groups, :ccd_height, :decimal, precision: 5, scale: 3
  end
end
