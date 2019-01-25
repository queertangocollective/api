class CreatePublishedPostsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :published_posts do |t|
      t.belongs_to :group, index: true
      t.belongs_to :channel, index: true
      t.belongs_to :post, index: true
      t.belongs_to :published_by, index: true

      t.text :title
      t.text :body
      t.string :slug, index: true
      t.boolean :featured, index: true, default: false

      t.timestamps
    end

    create_table :published_events, id: false do |t|
      t.belongs_to :published_post
      t.belongs_to :event
      t.index [:published_post_id, :event_id], name: 'index_published_events'
    end

    create_table :published_locations, id: false do |t|
      t.belongs_to :published_post
      t.belongs_to :location
      t.index [:published_post_id, :location_id], name: 'index_published_locations'
    end

    create_table :published_people do |t|
      t.belongs_to :published_post
      t.belongs_to :person
      t.index [:published_post_id, :person_id], name: 'index_published_people'
    end

    create_table :published_photos do |t|
      t.belongs_to :published_post
      t.belongs_to :photo
      t.index [:published_post_id, :photo_id], name: 'index_published_photos'
    end

    create_table :published_tickets do |t|
      t.belongs_to :published_post
      t.belongs_to :ticket
      t.index [:published_post_id, :ticket_id], name: 'index_published_tickets'
    end

    create_table :published_channels do |t|
      t.belongs_to :published_post
      t.belongs_to :channel
      t.index [:published_post_id, :channel_id], name: 'index_published_channels'
    end

    create_table :redirects do |t|
      t.belongs_to :group, index: true

      t.string :from, index: true
      t.string :to, index: true
    end

    add_index(:redirects, [:from, :to], :unique => true)
    add_index(:redirects, [:to, :from], :unique => true)
  end
end
