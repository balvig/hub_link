require "dotenv/load"
require "hub_link/configuration"
require "hub_link/stream"
require "hub_link/version"

module HubLink
  Configuration.new.apply
end
