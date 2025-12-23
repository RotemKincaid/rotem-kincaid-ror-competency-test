class AddRolesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :roles, :string, default: "user", null: false
  end
end
