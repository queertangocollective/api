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
    PublishedPost.where.not(id: @model.id).where(post_id: @model.post_id).update_all(live: false)

    # Collect and add relationships for everything embedded
    # in the post so we don't need to fetch it when we render
    # out
    json = JSON.parse(@model.body).with_indifferent_access
    json[:cards].each do |card|
      if card[0] == 'photo'
        photo = Photo.find_by_id(card[1][:photoId])
        PublishedPhoto.create(
          photo: photo,
          published_post: @model
        )
      elsif card[0] == 'gallery'
        photos = Photo.where(id: card[1][:photoIds])
        card[1] = photos.each do |photo|
          PublishedPhoto.create(
            photo: photo,
            published_post: @model
          )
        end
      elsif card[0] == 'itinerary'
        events = Event.where(id: card[1][:eventIds])
        card[1] = events.map do |event|
          PublishedEvent.create(
            event: event,
            published_post: @model
          )
        end
      elsif card[0] == 'location'
        location = Location.find_by_id(card[1][:locationId])
        PublishedLocation.create(
          location: location,
          published_post: @model
        )
      elsif card[0] == 'person'
        person = Person.find_by_id(card[1][:personId])
        PublishedPerson.create(
          person: person,
          published_post: @model
        )
      elsif card[0] == 'river'
        channel = Channel.find_by_id(card[1][:channelId])
        PublishedChannel.create(
          channel: channel,
          published_post: @model
        )
      elsif card[0] == 'ticket'
        ticket = Ticket.find_by_id(card[1][:ticketId])
        PublishedTicket.create(
          ticket: ticket,
          published_post: @model
        )
      end
    end
  end

  def self.records(options={})
    context = options[:context]
    posts = context[:group].posts
    if context[:current_user]
      posts
    else
      posts.published
    end
  end

end
