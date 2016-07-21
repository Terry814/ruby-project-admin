class CreateSocialStreams < ActiveRecord::Migration
  def change
    create_table :social_streams do |t|

      t.timestamps
    end
  end
end
