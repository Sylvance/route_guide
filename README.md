# RouteGuide

Route Guide is a gem that helps you to find the route to your destination.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add route_guide

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install route_guide

## Usage

You need to implement a server and a client. Then you can use this gem to connect between
the two. Check the `examples` folder for a working example.

### Server side service implementation

1. Create a `Gemfile` below then run `bundle` install:

```ruby
# frozen_string_literal: true

source "https://rubygems.org"

gem "grpc"
gem "route_guide"
```

2. Setup the gRPC server in `server.rb`:

```ruby
#!/usr/bin/env ruby

require 'grpc'
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
```

3. Run server with;

```sh
ruby server.rb
```

### Client side 

1. Do a client RPC call:

```ruby
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
  # 3. call the remote method with request object as parameter
  resp_obj = stub.direct_it(req)
  puts "Response: #{resp_obj}"
end

test_single_call
```

2. Then run the client in a separate terminal. Run client with;

```sh
ruby client.rb
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Resources

- Building Micro-services using gRPC on Ruby
    ```
    https://medium.com/@shiladitya16/building-micro-services-using-grpc-on-ruby-41acb755ee06
    ```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Sylvance/route_guide.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
