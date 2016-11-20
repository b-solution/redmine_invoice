class CreateInvoices < ActiveRecord::Migration
  def change

    create_table :invoices do |t|

      t.integer :project_id

      t.integer :issue_id

      t.integer :client_id

      t.float :issue_contract_amount

      t.float :tax_amount

      t.float :invoice_amount

      t.integer :issue_ratio_done

      t.timestamps

    end

  end
end
