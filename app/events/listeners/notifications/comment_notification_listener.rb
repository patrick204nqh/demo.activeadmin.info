module Events
  module Listeners
    module Notifications
      class CommentNotificationListener < BaseListener
        def call
          comment = @payload[:comment]
          author = comment&.author

          return unless author&.email.present?

          Rails.logger.debug "Initialized CommentNotificationListener with payload: #{@payload.inspect}"

          CommentNotificationJob.enqueue(comment.id)
        end
      end
    end
  end
end
