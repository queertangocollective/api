class MapboxService
  QUERY_URL = 'https://api.mapbox.com/geocoding/v5/mapbox.places'

  def geolocate(location)
    query = "#{location.address_line}, #{location.city}, #{location.region_code}, #{location.postal_code}"

    places = JSON.parse(
      HTTParty.get("#{QUERY_URL}/#{query.tr(' ', '+')}.json?access_token=#{ENV['MAPBOX_TOKEN']}",
                         headers: {
                           'Accept' => 'application/json',
                           'Content-Type' => 'application/json'
                         })
    )

    feature = places['features'].find { |feature| feature['place_type'].include?('postcode') } ||
              places['features'][0]
    feature['center']
  end
end
