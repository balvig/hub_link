require "facets/math"
require "octokit"

require "mergometer/version"
require "mergometer/configuration"
require "mergometer/report"

reports_path = File.expand_path("./reports/**/*.rb", __dir__)
Dir[reports_path].each { |f| require f }

module Mergometer
  Configuration.new(cache_time: 72 * 3600).apply
end
