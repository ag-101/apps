class AddRememberTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :remember_token, :string
    add_column :users, :email, :string
  end
end
