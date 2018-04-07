class ChangeUsersEmailColumnLength < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :email, :string, :limit => 50
    change_column :contacts, :email, :string, :limit => 50
  end
end
