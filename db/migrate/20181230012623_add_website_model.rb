class AddWebsiteModel < ActiveRecord::Migration[5.2]
  def change
    create_table :websites do |t|
      t.belongs_to :group, index: true
      t.string :sha, index: true
      t.json :assets

      t.timestamps
    end

    add_column :groups, :current_website_id, :integer
    add_column :groups, :glitch_url, :string
  end
end
