module CommentNotifications
  extend ActiveSupport::Concern

  included do
    after_create :notify_created
  end

  private

  def notify_created
    ActiveSupport::Notifications.instrument('comment.created', comment: self)
  end
end
