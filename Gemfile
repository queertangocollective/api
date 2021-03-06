source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'
gem 'git'
gem 'sassc'
gem 'autoprefixer-rails'
gem 'babel-transpiler'
gem 'mini_racer'

# Use postgres as the database for Active Record
gem 'pg'
gem 'pg_search'

gem 'stripe'
gem 'jsonapi-resources', '~> 0.9.0'
gem 'httparty'
gem 'nokogiri', '~> 1.8.1'
gem 'sentry-raven'

gem 'aws-sdk-s3'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'certified'
  gem 'dotenv-rails'
  gem 'letter_opener', '~> 1.6.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
