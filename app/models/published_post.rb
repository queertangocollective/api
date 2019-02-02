class PublishedPost < ApplicationRecord
  belongs_to :group
  belongs_to :post
  belongs_to :channel, optional: true
  belongs_to :published_by, class_name: 'Person'

  has_many :published_channels, dependent: :destroy
  has_many :published_events, dependent: :destroy
  has_many :published_locations, dependent: :destroy
  has_many :published_people, dependent: :destroy
  has_many :published_photos, dependent: :destroy
  has_many :published_tickets, dependent: :destroy

  def sync
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
        channel = channel.find_by_id(card[1][:channelId])
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
end
