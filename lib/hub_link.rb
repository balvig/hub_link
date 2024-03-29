require "dotenv/load"
require "hub_link/configuration"
require "hub_link/stream"
require "hub_link/importer"
require "hub_link/version"

module HubLink
  START = "HubLink::Started"
  UPDATE = "HubLink::Update"
  FINISH = "HubLink::Finished"

  class << self
    attr_accessor :config

    def logger
      config.logger
    end
  end

  self.config = Configuration.new
end
