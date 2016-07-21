class AddCoverImageStyleToApplicationInfo < ActiveRecord::Migration
  def change
    add_column :application_infos, :cover_image_style, :integer, default: 0
  end
end
