class ApiVersion
  attr_reader :version, :default

  DEFAULT_VERSION = "v1".freeze

  def initialize(version, default = false)
    @version = version || DEFAULT_VERSION
    @default = default
  end

  def matches?(request)
    check_headers(request.headers) || default
  end

  private

  def check_headers(headers)
    accept = headers[:accept]
    accept&.include?("application/vnd.api.#{version}+json")
  end
end
