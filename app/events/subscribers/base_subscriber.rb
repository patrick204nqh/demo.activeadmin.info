module Events
  module Subscribers
    class BaseSubscriber
      def initialize
        subscribe(event_name, configured_listeners)
      end

      private

      def event_name
        raise NotImplementedError, "#{self.class} must implement `event_name`"
      end

      def configured_listeners
        Events::Configuration::EventListeners.config[event_name] || []
      end

      def subscribe(event, listeners)
        ActiveSupport::Notifications.subscribe(event) do |_name, _start, _finish, _id, payload|
          listeners.each { |listener| listener.new(payload).call }
        end
      end
    end
  end
end
