source "https://rubygems.org"

ruby "3.3.4"

gem "rails", "~> 7.2.0"
gem "sqlite3"
gem "pg"
gem "puma"

gem "sprockets-rails"
gem "cssbundling-rails"
gem "importmap-rails"

gem "activeadmin", "4.0.0.beta14" # github: "activeadmin/activeadmin", branch: "master"
gem "devise"
gem "draper"
gem "cancancan"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Image processing
gem "image_processing"

group :development, :test do
  gem "foreman"
  gem "debug", platforms: %i[ mri windows ]
  gem "faker"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "simplecov-cobertura"
end
