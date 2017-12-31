class MapboxService
  QUERY_URL = 'https://api.mapbox.com/geocoding/v5/mapbox.places'

  def geolocate(location)
    query = "#{location.address_line}, #{location.city}, #{location.region_code}, #{location.postal_code}"

    places = Unirest.get("#{QUERY_URL}/#{query.tr(' ', '+')}.json?access_token=#{ENV['MAPBOX_TOKEN']}",
                         headers: {
                           'Accept' => 'application/json',
                           'Content-Type' => 'application/json'
                         }).body

    feature = places['features'].find do |feature|
      feature['context'].find { |ctx| ctx['id'].start_with?('postcode') }['text'] ==
        location.postal_code
    end || places['features'][0]

    feature['center']
  end
end
