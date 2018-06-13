require "facets/math"
require "octokit"

require "mergometer/version"
require "mergometer/configuration"
require "mergometer/runner"

reports_path = File.expand_path("../mergometer/reports/**/*.rb", __FILE__)
Dir[reports_path].each { |f| require f }

module Mergometer
  Configuration.new(cache_time: 72 * 3600).apply
  Runner.new(report_name: ARGV[0], repo_name: ARGV[1]).run
end
