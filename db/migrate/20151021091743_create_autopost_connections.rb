class CreateAutopostConnections < ActiveRecord::Migration
  def change
    create_table :autopost_connections do |t|
      t.references :autopost, index: true
      t.references :identity, index: true

      t.timestamps
    end
  end
end
