class AddColumnsToClient < ActiveRecord::Migration
  def change
    add_column :clients, :active, :boolean, default: true
    add_column :taxes, :active, :boolean, default: true

  end
end
