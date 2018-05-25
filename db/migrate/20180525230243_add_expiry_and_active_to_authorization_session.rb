class AddExpiryAndActiveToAuthorizationSession < ActiveRecord::Migration[5.2]
  def change
    add_column :authorization_sessions, :activated, :boolean
    add_column :authorization_sessions, :expires_at, :datetime
  end
end
