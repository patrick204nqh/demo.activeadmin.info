class CommentNotificationJob < ApplicationJob
  def run(comment_id)
    comment = ActiveAdmin::Comment.find_by(id: comment_id)

    return unless comment

    author = comment.resource.author
    return unless author&.email.present?

    CommentMailer.notify_author(comment, author).deliver_now

    # destroy
    finish
  end
end
