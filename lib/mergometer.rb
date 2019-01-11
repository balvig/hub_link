require "dotenv/load"
require "mergometer/configuration"
require "mergometer/stream"
require "mergometer/version"

module Mergometer
  Configuration.new(cache_time: 72 * 3600).apply
end
