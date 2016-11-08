class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|

      t.string :name
      t.string :type

      t.float :rate

      t.date :applicable_from

      t.timestamps
    end

  end
end
