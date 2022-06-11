require 'grpc'
require 'route_guide'

class DirectionsService < RouteGuide::DirectionsService::Service
  def direct_it(direction_req, _unused_call)
    puts "Received direction request for #{direction_req}"
    RouteGuide::DirectionsResponse.new(
      directions: response.direction,
      approximate_time_of_travel_in_hrs: response.approximate_time_of_travel_in_hrs,
      approximate_distance_in_kms: response.approximate_distance_in_kms
    )
  end
end
