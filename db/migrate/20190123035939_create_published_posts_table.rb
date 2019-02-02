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
      t.boolean :live, index: true, default: false

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

    # Automatically create published posts
    reversible do |direction|
      direction.up do
        posts = Post.where(published: true)
        posts.each do |post|
          model = PublishedPost.create(
            group: post.group,
            channel: post.channel,
            post: post,
            published_by: post.authors.last.person,
            title: post.title,
            body: post.body,
            slug: post.slug,
            featured: post.pinned,
            live: true
          )

          # Collect and add relationships for everything embedded
          # in the post so we don't need to fetch it when we render
          # out
          json = JSON.parse(model.body).with_indifferent_access
          records = {
            photos: [],
            locations: [],
            events: [],
            channels: [],
            people: [],
            tickets: []
          }

          json[:cards].each do |card|
            if card[0] == 'photo'
              photo = Photo.find_by_id(card[1][:photoId])
              records[:photos] << photo
            elsif card[0] == 'gallery'
              photos = Photo.where(id: card[1][:photoIds])
              card[1] = photos.each do |photo|
                records[:photos] << photo
              end
            elsif card[0] == 'itinerary'
              events = Event.where(id: card[1][:eventIds])
              card[1] = events.map do |event|
                records[:events] << event
              end
            elsif card[0] == 'location'
              location = Location.find_by_id(card[1][:locationId])
              records[:locations] << location
            elsif card[0] == 'person'
              person = Person.find_by_id(card[1][:personId])
              records[:people] << person
            elsif card[0] == 'river'
              channel = Channel.find_by_id(card[1][:channelId])
              records[:channels] << channel
            elsif card[0] == 'ticket'
              ticket = Ticket.find_by_id(card[1][:ticketId])
              records[:tickets] << ticket
            end
          end

          # Loop through all records and create their relations
          records.keys.each do |key|
            records[key].uniq.each do |relation|
              model_name = key.to_s.singularize.titleize
              published_model_name = "Published#{model_name}"
              attributes = { published_post: model }
              attributes[model_name.underscore.to_sym] = relation
              published_model_name.constantize.create(attributes)
            end
          end
        end
      end
    end
  end
end
