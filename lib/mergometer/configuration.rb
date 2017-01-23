module Mergometer
  class Configuration
    require "faraday/detailed_logger"
    require "faraday_middleware"
    require "active_support/cache"

    def apply
      Octokit.middleware = middleware
    end

    private

      def middleware
        Faraday::RackBuilder.new do |builder|
          builder.response :detailed_logger, logger
          builder.response :caching, cache
          builder.use Octokit::Response::RaiseError
          builder.adapter Faraday.default_adapter
        end
      end

      def cache
        ActiveSupport::Cache::FileStore.new "tmp/cache", expires_in: 3600 # one hour
      end

      def logger
        logger = Logger.new("tmp/github.log")
        logger.level = Logger::INFO
        logger
      end
  end
end
