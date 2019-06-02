module HubLink
  class SimpleLogger < SimpleDelegator
    def initialize(output = "hub_link.log")
      logger = Logger.new(output)
      logger.formatter = ->(_, datetime, _, msg) { "#{datetime} - #{msg}\n" }
      __setobj__(logger)
    end
  end
end

