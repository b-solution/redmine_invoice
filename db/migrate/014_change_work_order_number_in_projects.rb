class ChangeWorkOrderNumberInProjects < ActiveRecord::Migration
  def change
    change_column :projects, :work_order_number, :string
    add_column :issues, :item_number, :integer
  end
end
