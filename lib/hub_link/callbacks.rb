# https://gist.github.com/nilbus/6385142
module HubLink
  class Callbacks
    def initialize(block)
      block&.call(self)
    end

    def callback(message, *args)
      callbacks[message]&.call(*args)
    end

    def method_missing(m, *args, &block)
      block ? callbacks[m] = block : super
      self
    end

    private

      def callbacks
        @callbacks ||= {}
      end
  end
end
