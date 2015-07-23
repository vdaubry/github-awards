source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails',                        '~> 4.2.0'
gem 'sass-rails',                   '~> 5.0'
gem 'uglifier',                     '~> 2.7.0'
gem 'turbolinks',                   '~> 2.5.3'
gem 'yajl-ruby',                    '~> 1.2.1'
gem 'pg',                           '~> 0.18.2'
gem 'sidekiq',                      '~> 3.4.2'
gem 'sidekiq-throttler',            '~> 0.4.1'
gem 'octokit',                      '~> 3.7.0'
gem 'octicons-rails',               '~> 2.1.1'
gem 'actionpack-action_caching',    '~> 1.1.1'
gem 'redis',                        '~> 3.2.0'
gem 'puma',                         '~> 2.11.1'
gem 'httparty',                     '~> 0.13.3'
gem 'kaminari',                     '~> 0.16.3'
gem 'dalli',                        '~> 2.7.4'
gem 'omniauth-github',              '~> 1.1.2'


group :development do
  gem 'quiet_assets',               '~> 1.1.0'
  gem 'web-console',                '~> 2.0'
  gem 'spring',                     '~> 1.2.0'
  gem 'capistrano-rails',           '~> 1.1.2'
  gem 'capistrano-bundler',         '~> 1.1.4'
  gem 'sitemap_generator',          '~> 5.0.5'
end

group :test do
  gem 'rspec-rails',                '~> 3.0'
  gem 'factory_girl_rails',         '~> 4.5.0'
  gem 'mocha',                      '~> 1.1.0'
  gem 'fakeredis',                  '~> 0.5.0'
  gem 'webmock',                    '~> 1.20.4'
  gem 'vcr',                        '~> 2.9.3'
end

group :development, :test do
  gem 'byebug',                      '~> 3.5.1'
end

group :production do
  gem 'newrelic_rpm',               '~> 3.9.9.275'
  gem "sentry-raven",               :git => "https://github.com/getsentry/raven-ruby.git"
end
