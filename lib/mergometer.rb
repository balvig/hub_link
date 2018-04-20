require "facets/math"
require "octokit"

require "mergometer/version"
require "mergometer/configuration"
require "mergometer/report"

module Mergometer
  Configuration.new(cache_time: 72 * 3600).apply

  Report.new(ARGV[0], ARGV[1])
end
