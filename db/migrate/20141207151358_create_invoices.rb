class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.date :date
      t.string :description
      t.float :total
      t.references :billing_info, index: true
      t.string :stripe_id

      t.timestamps
    end
  end
end
