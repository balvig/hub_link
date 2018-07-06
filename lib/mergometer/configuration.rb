module Mergometer
  class Configuration
    require "faraday/detailed_logger"
    require "faraday_middleware"
    require "active_support"

    def initialize(cache_time: 3600)
      @cache_time = cache_time
    end

    def apply
      Octokit.middleware = middleware
      Octokit.auto_paginate = true
    end

    private

      attr_reader :cache_time

      def middleware
        Faraday::RackBuilder.new do |builder|
          builder.response :detailed_logger, logger
          builder.response :caching, cache
          builder.use Octokit::Response::RaiseError
          builder.adapter Faraday.default_adapter
        end
      end

      def cache
        ActiveSupport::Cache::FileStore.new "tmp/cache", expires_in: cache_time
      end

      def logger
        logger = Logger.new(STDOUT)
        logger.level = Logger::INFO
        logger
      end
  end
end
