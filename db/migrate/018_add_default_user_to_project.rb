class AddDefaultUserToProject < ActiveRecord::Migration
  def change
   add_column :projects, :default_user_id, :integer
  end
end
