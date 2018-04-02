class AddDefaultValueToUserTokenActiveColumn < ActiveRecord::Migration[5.1]
  def change
    change_column :user_tokens, :active, :boolean, default: true
  end
end
