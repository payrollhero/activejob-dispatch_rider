# ActiveJob::DispatchRider

[![Gem Version](https://badge.fury.io/rb/activejob-dispatch_rider.svg)](http://badge.fury.io/rb/activejob-dispatch_rider)
[![Code Climate](https://codeclimate.com/github/payrollhero/activejob-dispatch_rider/badges/gpa.svg)](https://codeclimate.com/github/payrollhero/activejob-dispatch_rider)
[![Test Coverage](https://codeclimate.com/github/payrollhero/activejob-dispatch_rider/badges/coverage.svg)](https://codeclimate.com/github/payrollhero/activejob-dispatch_rider)

[![Circle CI](https://circleci.com/gh/payrollhero/activejob-dispatch_rider.png?style=badge)](https://circleci.com/gh/payrollhero/activejob-dispatch_rider)


'ActiveJob::DispatchRider' adds `DispatchRider` support for `ActiveJob`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "activejob-dispatch_rider"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activejob-dispatch_rider

## Usage

Configure `ActiveJob` and `DispatchRider`.

### Stand-alone

```ruby
# publisher app

# Set the ActiveJob's queue adapter
ActiveJob::Base.queue_adapter = :dispatch_rider

# Configure DispatchRider::Publisher as you would normally do
DispatchRider::Publisher.configure notification_services: { file_system: {} },
                                   destinations: {
                                     low_priority: {
                                       service: :file_system,
                                       channel: :low_priority,
                                       options: { path: "tmp/queue/low" }
                                     },
                                     high_priority: {
                                       service: :file_system,
                                       channel: :high_priority,
                                       options: { path: "tmp/queue/high" }
                                     }
                                   }
```

```ruby
# subscriber app for low priority channel
DispatchRider.configure do |config|
  config.queue_kind = "file_system"
  config.queue_info = { path: "tmp/queue/low" }
end
```

```ruby
# subscriber app for high priority channel
DispatchRider.configure do |config|
  config.queue_kind = "file_system"
  config.queue_info = { path: "tmp/queue/high" }
end
```

### Rails


```ruby
# config/application.rb
module YourApp
  class Application < Rails::Application
    # ...
    config.active_job.queue_adapter = :dispatch_rider
    # ...
  end
end
```

```ruby
# Configure DispatchRider::Publisher as you would normally do

# config/initializers/dispatch_rider.rb
DispatchRider::Publisher.configure notification_services: { file_system: {} },
                                   destinations: {
                                     low_priority: {
                                       service: :file_system,
                                       channel: :low_priority,
                                       options: { path: "tmp/queue/low" }
                                     },
                                     high_priority: {
                                       service: :file_system,
                                       channel: :high_priority,
                                       options: { path: "tmp/queue/high" }
                                     }
                                   }

# subscriber app for low priority channel
DispatchRider.configure do |config|
  config.queue_kind = "file_system"
  config.queue_info = { path: "tmp/queue/low" }
end
```

Once the preliminary setup is done create active jobs like you normally would.
Match the destination channel name of `DispatchRider` with the queue name of
`ActiveJob`.

```ruby
# call_and_welcome_customer.rb
class CallAndWelcomeCustomer < ActiveJob::Base
  queue_as :high_priority

  def perform(customer, welcome_message:)
    call_phone customer.phone_number
    say welcome_message
    # ...
  end
  # ...
end
```

To perform the job later enqueue it by calling `.perform_later`.
```ruby
CallAndWelcomeCustomer.perform_later Customer.find_by_name!("Smith"),
                                     welcome_message: "Welcome Mr. Smith!"
```

## Contributing

1. Fork it ( https://github.com/payrollhero/activejob-dispatch_rider/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

Special thanks to those who contributed to this project. :smile:

* [@fredbaa](https://github.com/fredbaa)
