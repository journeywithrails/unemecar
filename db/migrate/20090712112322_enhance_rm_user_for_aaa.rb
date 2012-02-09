class EnhanceRmUserForAaa < ActiveRecord::Migration
  def self.up

  	add_column :rm_users, :email_hash, :string
  	add_column :rm_users, :login, :string
  	add_column :rm_users, :email, :string
  	add_column :rm_users, :crypted_password, :string
  	add_column :rm_users, :salt, :string
  	add_column :rm_users, :remember_token, :string
  	add_column :rm_users, :remember_token_expires_at, :datetime
  	
  end

  def self.down
  end
end
