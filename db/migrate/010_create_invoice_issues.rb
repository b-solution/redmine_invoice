class CreateInvoiceIssues < ActiveRecord::Migration
  def change
    create_table :invoice_issues do |t|

      t.integer :issue_id
      t.integer :invoice_id
      t.integer :ratio_done
      t.integer :rate
      t.float :issue_contract_amount

    end

  end
end
