module Events
  module Listeners
    class BaseListener
      def initialize(payload)
        @payload = payload
      end

      def call
        raise NotImplementedError, "#{self.class} must implement the `call` method"
      end
    end
  end
end
