module Events
  module Subscribers
    class CommentSubscriber < BaseSubscriber
      private

      def event_name
        'comment.created'
      end
    end
  end
end
