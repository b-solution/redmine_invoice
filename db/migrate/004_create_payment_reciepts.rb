class CreatePaymentReciepts < ActiveRecord::Migration
  def change
    create_table :payment_receipts do |t|

      t.integer :project_id
      t.integer :issue_id

      t.integer :invoice_id

      t.string :cheque_no

      t.string :bank_name

      t.date :date_on_cheque

      t.string :cheque_amount

      t.timestamps

    end

  end
end
