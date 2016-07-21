class CreateWebLinks < ActiveRecord::Migration
  def change
    create_table :web_links do |t|
      t.string :url
      t.string :label
      t.references :application_info, index: true

      t.timestamps
    end
  end
end
