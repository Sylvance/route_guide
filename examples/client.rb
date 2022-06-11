#!/usr/bin/env ruby

require 'grpc'
require 'route_guide'

def test_single_call
  # 1. connect to server service
  stub = RouteGuide::DirectionsService::Stub.new('0.0.0.0:50052', :this_channel_is_insecure)
  # 2. build request object
  req = RouteGuide::DirectionsRequest.new(
    current_location: 'current_location',
    target_location: 'travel_location',
    means_of_travel: 'means_of_travel'
  )
  # 3. call remote method with request object as parameter
  resp_obj = stub.direct_it(req)
  puts "Response: #{resp_obj}"
end

test_single_call
