class AddBuilds < ActiveRecord::Migration[5.1]
  def change
    create_table :builds do |t|
      t.text       :notes
      t.text       :git_url
      t.string     :git_sha
      t.text       :signature
      t.belongs_to :public_key
      t.belongs_to :group
      t.boolean    :live, index: true
      t.datetime   :live_at, index: true
      t.text       :html

      t.timestamps
    end

    create_table :public_key do |t|
      t.string     :name, null: false, limit: 191
      t.text       :key, null: false

      t.timestamps
    end

    add_column :groups, :current_build_id, :integer
  end
end
