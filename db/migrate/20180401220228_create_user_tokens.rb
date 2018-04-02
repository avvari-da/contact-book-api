class CreateUserTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :user_tokens do |t|
      t.string :access_token
      t.boolean :active
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
