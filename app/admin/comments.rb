ActiveAdmin.register ActiveAdmin::Comment, as: 'Comment' do
  member_action :resend_notification, method: :post do
    ActiveSupport::Notifications.instrument('comment.created', comment: resource)
    redirect_to resource_path, notice: 'Notification email resent successfully.'
  end

  action_item :resend_notification, only: :show do
    link_to 'Resend Notification', resend_notification_admin_comment_path(resource), method: :post
  end
end