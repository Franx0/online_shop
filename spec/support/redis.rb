require 'redis-rails'

RSpec.configure do |config|
  config.after(:each) do
    Redis.current.flushdb if Redis.current.present?
  end
end
