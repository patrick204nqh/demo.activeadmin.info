class CommentNotificationJob < ApplicationJob
  # self.run_at = proc { 1.seconds.from_now }

  # self.priority = 10

  def run(comment_id)
    puts "Running CommentNotificationJob for comment_id: #{comment_id}"

    comment = ActiveAdmin::Comment.find_by(id: comment_id)

    return unless comment

    author = comment.resource.author
    return unless author&.email.present?

    CommentMailer.notify_author(comment, author).deliver_now

    # destroy
    finish
  end
end
