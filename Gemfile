source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks'
gem 'yajl-ruby'
gem 'pg', '0.18.1'
gem 'sidekiq'
gem 'sidekiq-throttler'
gem 'octokit'
gem 'octicons-rails'
gem 'actionpack-action_caching'
gem 'redis'
gem 'puma'
gem 'httparty'
gem 'kaminari'



group :development do
  gem 'quiet_assets'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'sitemap_generator'
  
  #required for google storage
  gem 'google-api-client'
  gem 'highline'
  gem 'thin'
  gem 'launchy'
end

group :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails'
  gem 'mocha'  
end

group :development, :test do
  gem 'byebug'
end

group :production do
  gem 'newrelic_rpm'
end
