#!/usr/bin/env ruby

require 'rubygems'
require 'route_guide'
require_relative 'directions_service'

class RouteGuideServer
  class << self
    def start
      start_grpc_server
    end

    private

    def start_grpc_server
      @server = GRPC::RpcServer.new
      @server.add_http2_port("0.0.0.0:50052", :this_port_is_insecure)
      @server.handle(DirectionsService)
      @server.run_till_terminated
    end
  end
end

RouteGuideServer.start
