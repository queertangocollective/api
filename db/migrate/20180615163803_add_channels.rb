class AddChannels < ActiveRecord::Migration[5.2]
  def change
    create_table :channels do |t|
      t.belongs_to :group, index: true
      t.string :locale
      t.string :name
      t.string :slug
      t.boolean :published, default: false, index: true

      t.timestamps
    end
    add_index :channels, [:locale, :slug], unique: true

    add_column :posts, :channel_id, :integer
    add_column :groups, :apple_developer_merchantid_domain_association, :text
  end
end
