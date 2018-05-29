require "facets/math"
require "octokit"
require "ostruct"

reports_path = File.expand_path("./mergometer/**/*.rb", __dir__)
Dir[reports_path].each { |f| require f }

module Mergometer
  Configuration.new(cache_time: 72 * 3600).apply
end
