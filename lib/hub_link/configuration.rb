require "octokit"
require "faraday_middleware"
require "active_support"
require "hub_link/simple_logger"
require "hub_link/api/logging"

module HubLink
  class Configuration
    RETRY_ON = Faraday::Request::Retry::DEFAULT_EXCEPTIONS + [Octokit::BadGateway]
    attr_accessor :logger

    def initialize
      self.logger = SimpleLogger.new
      Octokit.middleware = middleware
      Octokit.auto_paginate = false
    end

    private

      attr_reader :cache_time

      def middleware
        Faraday::RackBuilder.new do |builder|
          builder.use Api::Logging
          builder.request :retry, exceptions: RETRY_ON
          builder.use Octokit::Response::RaiseError
          builder.adapter Faraday.default_adapter
        end
      end
  end
end
