class AddEcpChequeAmountToPayment < ActiveRecord::Migration
  def change
    add_column :payment_receipts, :exp_cheque_amount, :integer
  end
end
