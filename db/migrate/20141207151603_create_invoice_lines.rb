class CreateInvoiceLines < ActiveRecord::Migration
  def change
    create_table :invoice_lines do |t|
      t.string :description
      t.float :amount
      t.references :invoice, index: true

      t.timestamps
    end
  end
end
