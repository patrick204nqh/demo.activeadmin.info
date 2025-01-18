module Events
  module Configuration
    class EventListeners
      class << self
        def config
          {
            'comment.created' => [
              Events::Listeners::Notifications::CommentNotificationListener,
            ]
          }
        end
      end
    end
  end
end
