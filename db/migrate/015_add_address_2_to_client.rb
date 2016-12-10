class AddAddress2ToClient < ActiveRecord::Migration
  def change

    add_column :clients, :home_address_2, :string
  end
end
