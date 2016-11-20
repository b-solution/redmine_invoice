class AddColumns < ActiveRecord::Migration
  def change
    add_column :projects, :client_id, :integer
    add_column :projects, :work_order_date, :date
    add_column :projects, :work_order_number, :integer

    add_column :issues, :contract_amount, :float

  end
end
