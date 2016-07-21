class CreateOpenTables < ActiveRecord::Migration
  def change
    create_table :open_tables do |t|
      t.string :url

      t.timestamps
    end
  end
end
