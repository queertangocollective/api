class CreateModels < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.text   :name,  null: false
      t.string :email, null: false
      t.string :hostname, null: false
      t.string :api_key, null: false
      t.string :timezone, null: false
      t.string :locale, null: false

      t.timestamps
    end

    create_table :people do |t|
      t.belongs_to :group, index: true

      t.text   :name, null: false, index: true
      t.string :email, null: false, index: true
      t.text   :biography
      t.text   :website
      t.string :role
      t.boolean :public, default: false, index: true

      t.timestamps
    end

    create_table :authorizations do |t|
      t.belongs_to :group, index: true

      t.string :email, null: false, default: ''
      t.text :avatar
      t.belongs_to :person, null: false, index: true

      ## Trackable
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet :current_sign_in_ip
      t.inet :last_sign_in_ip

      ## Omniauth
      t.string :uid
      t.string :provider

      t.timestamps null: false
    end
    add_index :authorizations, [:email, :provider], unique: true

    create_table :authorization_sessions do |t|
      t.belongs_to :authorization, index: true
      t.string :session_id, index: true, unique: true

      t.timestamps
    end

    create_table :transactions do |t|
      t.belongs_to :group, index: true

      t.text :description, index: true
      t.datetime :paid_at, index: true
      t.text :paid_by, index: true
      t.belongs_to :receipt
      t.integer :amount_paid
      t.integer :amount_owed
      t.string :currency
      t.string :payment_method
      t.text :payment_processor_url
      t.text :notes
      t.belongs_to :ticket, index: true

      t.timestamps
    end

    create_table :tickets do |t|
      t.belongs_to :group, index: true

      t.text :description
      t.string :sku
      t.integer :cost
      t.integer :quantity
      t.string :currency
      t.datetime :valid_from
      t.datetime :valid_to

      t.timestamps
    end

    create_table :ticketed_event do |t|
      t.belongs_to :ticket, index: true
      t.belongs_to :event, index: true
    end

    create_table :ticket_stubs do |t|
      t.belongs_to :group, index: true
      t.belongs_to :person, index: true
      t.belongs_to :event, index: true
      t.belongs_to :transaction, index: true
      t.belongs_to :ticket, index: true

      t.boolean :attended
      t.string :role
      t.string :level
      t.text :notes

      t.timestamps
    end

    create_table :photos do |t|
      t.belongs_to :group, index: true

      t.text :url
      t.string :filename
      t.integer :filesize
      t.integer :width
      t.integer :height
      t.text :title
      t.text :caption
      t.text :tags, array: true

      t.timestamps
    end

    create_table :portraits do |t|
      t.belongs_to :person, index: true
      t.belongs_to :photo, index: true
    end

    create_table :events do |t|
      t.belongs_to :group, index: true

      t.text :title, index: true
      t.text :description
      t.string :level
      t.datetime :starts_at
      t.datetime :ends_at
      t.belongs_to :venue

      t.timestamps
    end

    create_table :guests do |t|
      t.belongs_to :event
      t.belongs_to :person

      t.text :role

      t.timestamps
    end

    create_table :posts do |t|
      t.belongs_to :group, index: true

      t.text :title, index: true
      t.text :body
      t.string :slug, index: true
      t.datetime :published_at, index: true
      t.boolean :published, index: true, default: false
      t.boolean :pinned, index: true, default: false

      t.timestamps
    end

    create_table :locations do |t|
      t.belongs_to :group, index: true

      t.text :name
      t.text :website
      t.text :address_line
      t.text :extended_address
      t.text :city
      t.string :region_code
      t.string :postal_code
      t.belongs_to :photo, index: true
      t.string :latitude
      t.string :longitude

      t.timestamps
    end

    create_table :venues do |t|
      t.belongs_to :location, index: true
      t.belongs_to :event, index: true

      t.text :extended_address
      t.text :notes

      t.timestamps
    end
  end
end
