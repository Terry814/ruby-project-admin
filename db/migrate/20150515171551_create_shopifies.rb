class CreateShopifies < ActiveRecord::Migration
  def change
    create_table :shopifies do |t|
      t.string :url

      t.timestamps
    end
  end
end
