require 'json'

class PagesController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def group
    return @group if @group
    @group = Group.find_by_api_key(encrypted_api_key)
  end

  def index
    post = Group.first.posts.find_by_slug(params[:slug])
    if post.nil?
      head :not_found
      return
    end

    body = hydrate_mobiledoc(post.body)
    photo = body[:cards].find { |card| card[0] == 'photo' }
    description = body[:sections].find { |section| section[2].present? }
    if description.nil?
      person = body[:cards].find { |card| card[0] == 'person' }
      if person
        photo = person[1][:biography][:cards].find { |card| card[0] == 'photo' }
        description = person[1][:biography][:sections].find { |section| section[2].present? }
      end
    end

    render json: {
      title: post.title,
      description: description[2][0][3],
      photo: photo.try(:last),
      body: body
    }
  end

  def hydrate_mobiledoc(body)
    json = JSON.parse(body).with_indifferent_access
    json[:cards].each do |card|
      if card[0] == 'photo'
        photo = Photo.find(card[1][:photoId])
        card[1] = {
          url: photo.cloudfront_url,
          width: photo.width,
          height: photo.height,
          caption: card[1][:caption]
        }
      elsif card[0] == 'gallery'
        photos = Photo.find(card[1][:photoIds])
        card[1] = photos.each do |photo|
          {
            url: photo.cloudfront_url,
            width: photo.width,
            height: photo.height,
            caption: card[1][:caption]
          }
        end
      elsif card[0] == 'itinerary'
        events = Event.find(card[1][:eventIds])
        card[1] = events.map do |event|
          {
            name: event.title,
            startsAt: event.starts_at,
            endsAt: event.ends_at,
            guests: event.guests.map do |guest|
              {
                name: guest.person.name,
                biography: hydrate_mobiledoc(guest.person.biography),
                website: guest.person.website,
                role: guest.role
              }
            end,
            description: if event.description; hydrate_mobiledoc(event.description); end
          }
        end
      elsif card[0] == 'location'
        location = Location.find(card[1][:locationId])
        card[1] = {
          photo: if location.photo then {
            url: location.photo.cloudfront_url,
            width: location.photo.width,
            height: location.photo.height
          } end,
          website: location.website,
          addressLine: location.address_line,
          extendedAddress: card[1][:extendedAddress],
          city: location.city,
          regionCode: location.region_code,
          postalCode: location.postal_code,
          latitude: location.latitude,
          longitude: location.longitude
        }
      elsif card[0] == 'person'
        person = Person.find(card[1][:personId])
        card[1] = {
          name: person.name,
          biography: hydrate_mobiledoc(person.biography),
          website: person.website
        }
      elsif card[0] == 'ticket'
        ticket = Ticket.find(card[1][:ticketId])
        card[1] = {
          id: ticket.id,
          callToAction: card[1][:callToAction],
          description: ticket.description,
          cost: ticket.cost,
          currency: ticket.currency
        }
      end
    end
    json
  end

  def api_key
    request.headers['ApiKey'] || request.headers['Api-Key'] || ''
  end

  def encrypted_api_key
    Digest::SHA2.new(512).hexdigest(api_key)
  end

  def not_found
    head :not_found
  end

  def internal_server_error
    head :internal_server_error
  end
end
