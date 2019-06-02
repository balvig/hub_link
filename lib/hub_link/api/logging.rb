module HubLink
  module Api
    class Logging < Faraday::Response::Middleware
      def call(env)
        message = "#{env[:method].upcase} #{env[:url]}".sub("https://api.github.com/repos", "")
        logger.info(UPDATE) { message }
        super
      end

      private

        def logger
          HubLink.logger
        end
    end
  end
end
