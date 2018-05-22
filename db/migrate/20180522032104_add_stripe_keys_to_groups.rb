class AddStripeKeysToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :encrypted_stripe_publishable_key, :text
    add_column :groups, :encrypted_stripe_secret_key, :text
  end
end
