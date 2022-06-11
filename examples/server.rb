#!/usr/bin/env ruby

require 'grpc'
require 'rubygems'
require 'route_guide'

class DirectionsService < RouteGuide::DirectionsService::Service
  def direct_it(direction_req, _unused_call)
    puts "Received direction request for #{direction_req}"
    # build response from object
    RouteGuide::DirectionsResponse.new(
      directions: 'response',
      approximate_time_of_travel_in_hrs: 4,
      approximate_distance_in_kms: 30
    )
  end
end

class RouteGuideServer
  class << self
    def start
      start_grpc_server
    end

    private

    def start_grpc_server
      # create server
      @server = GRPC::RpcServer.new
      @server.add_http2_port("0.0.0.0:50052", :this_port_is_insecure)
      # assign server to a grpc handler
      @server.handle(DirectionsService)
      @server.run_till_terminated
    end
  end
end

RouteGuideServer.start
