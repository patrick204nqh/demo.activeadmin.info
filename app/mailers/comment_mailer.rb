class CommentMailer < ApplicationMailer
  def notify_author(comment, author)
    @comment = comment
    @author = author

    mail(
      to: author.email,
      subject: 'New Comment on Your Post'
    )
  end
end
