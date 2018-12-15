require "mergometer/configuration"
require "mergometer/reports_generator"
require "mergometer/version"

module Mergometer
  Configuration.new(cache_time: 72 * 3600).apply
end
