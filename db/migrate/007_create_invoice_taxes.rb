class CreateInvoiceTaxes < ActiveRecord::Migration
  def change
    create_table :invoice_taxes do |t|

      t.integer :invoice_id

      t.integer :tax_id
      t.float :rate


    end

  end
end
