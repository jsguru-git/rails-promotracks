source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
# gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
# Use CoffeeScript for .coffee assets and views
gem 'devise'
gem 'slim'
gem 'slim-rails'
gem 'simple_token_authentication'
gem 'figaro'
gem 'time_difference'
gem 'thin'
gem 'settingslogic'
gem 'browser-timezone-rails'
gem 'timezone', '~> 1.0'
gem 'geocoder'

gem "select2-rails"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-datatables-rails', '~> 3.4.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'sass-rails', '~> 5.0'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.47'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'aws-sdk'
gem 'carrierwave'
gem 'activemodel-serializers-xml'
gem 'data-confirm-modal'

gem 'devise_invitable', '~> 1.7.0'

gem 'sidekiq'
gem 'sinatra', :require => nil
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'faker'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

gem 'kaminari'
gem 'capistrano-bundler'

group :development do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-rvm'
  gem 'capistrano-rails', '~> 1.1.0'
  gem 'capistrano-thin'
  gem 'capistrano-sidekiq'
  gem 'capistrano-faster-assets', '~> 1.0'
end

#Slack integreation
gem 'slackistrano'

#Assets
gem 'asset_sync'
gem "fog-aws"

group :assets do
  gem "fog", "~>1.20", require: "fog/aws/storage"
  gem 'coffee-rails', '~> 4.1.0'
  gem 'uglifier', '>= 1.3.0'
end

#SES
gem 'aws-ses', '~> 0.6.0', :require => 'aws/ses'

#exception notification
gem 'exception_notification'

#newrelic monitoring
gem 'newrelic_rpm'