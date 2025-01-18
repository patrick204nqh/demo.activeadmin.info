Dir[Rails.root.join('app', 'events', '**', '*.rb')].each { |file| require file }

Rails.application.config.to_prepare do
  Events::Subscribers::CommentSubscriber.new
end
