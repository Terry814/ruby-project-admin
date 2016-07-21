class CreatePdfFileItems < ActiveRecord::Migration
  def change
    create_table :pdf_file_items do |t|
      t.attachment :pdf_file

      t.timestamps
    end
  end
end
