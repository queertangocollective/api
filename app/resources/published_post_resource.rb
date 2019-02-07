require 'json'

class PublishedPostResource < ApplicationResource
  attributes :title, :body, :slug, :featured, :live

  has_one :post
  has_one :channel, always_include_linkage_data: true
  has_one :published_by, class_name: 'Person', always_include_linkage_data: true

  before_create do
    @model.group = context[:group]
    @model.published_by = context[:current_user]
    @model.live = true
  end

  after_create do
    if PublishedPost.where(post_id: @model.post_id).count
      PublishedPost.where.not(id: @model.id).where(post_id: @model.post_id).update_all(live: false)
    end

    # Collect and add relationships for everything embedded
    # in the post so we don't need to fetch it when we render
    # out
    json = JSON.parse(@model.body || '{ cards: [] }').with_indifferent_access
    records = {}

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
        attributes = { published_post: @model }
        attributes[model_name.underscore.to_sym] = relation
        published_model_name.constantize.create(attributes)
      end
    end
  end

  def self.records(options={})
    context = options[:context]
    posts = context[:group].published_posts
    if context[:current_user]
      posts
    else
      posts.where(live: true)
    end
  end

end
