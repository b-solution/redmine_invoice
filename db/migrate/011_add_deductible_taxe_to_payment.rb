class AddDeductibleTaxeToPayment < ActiveRecord::Migration
  def change
    add_column :payment_receipts, :deductible_taxes, :float
  end
end
