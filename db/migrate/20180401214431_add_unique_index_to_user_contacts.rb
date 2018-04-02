class AddUniqueIndexToUserContacts < ActiveRecord::Migration[5.1]
  def change
    add_index :contacts, [:user_id, :email], unique: true
  end
end
