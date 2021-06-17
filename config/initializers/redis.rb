Redis.current = Redis.new(host: (ENV.fetch('REDIS_HOST') { nil } || Rails.application.credentials.config.dig(:redis, :host) ||  'localhost'), port: 6379, db: Rails.env.test? ? 9 : 2)
