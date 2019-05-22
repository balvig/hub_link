require "faraday/detailed_logger"
require "faraday_middleware"
require "active_support"

module HubLink
  class Configuration
    def apply
      Octokit.middleware = middleware
    end

    private

      attr_reader :cache_time

      def middleware
        Faraday::RackBuilder.new do |builder|
          builder.response :detailed_logger, logger
          builder.request :retry
          builder.use Octokit::Response::RaiseError
          builder.adapter Faraday.default_adapter
        end
      end

      def logger
        logger = Logger.new("hub_link.log")
        logger.formatter = ->(_, datetime, _, msg) { "#{datetime.to_s(:db)} - #{msg}\n" }
        logger.level = Logger::INFO
        logger
      end
  end
end
