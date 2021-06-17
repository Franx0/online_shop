module Cacheable
  extend ActiveSupport::Concern

  def set_cache(key:, values:)
    Redis.current.set(key, values)
  end

  def get_keys(key:)
    Redis.current.scan(0, match: key)
  end

  def get_cache(key:)
    return false unless key
    Redis.current.get(key)
  end

  def flush_keys(keys:)
    Redis.current.del(*keys)
  end
end
