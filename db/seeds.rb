# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
admin = User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# Create multiple Categories and Posts using Faker
require 'faker'

categories = ["Technology", "Health", "Travel", "Food", "Education"].map do |category_name|
  Category.find_or_create_by!(name: category_name)
end

categories.each do |category|
  3.times do
    post = Post.create!(
      title: Faker::Book.title,
      content: Faker::Lorem.paragraphs(number: 3).join("\n\n"),
      category: category,
      author: admin
    )
    
    # Create comments for each post
    2.times do
      ActiveAdmin::Comment.create!(
        namespace: "admin",
        author: admin,
        resource: post,
        body: Faker::Quotes::Shakespeare.hamlet_quote,
      )
    end
  end
end
