class AddAmountToInvoice < ActiveRecord::Migration
  def change
   add_column :invoices, :original_amount,:float, default: 0
   add_column :invoices, :old_amount, :float, default: 0

  end
end
