source "http://rubygems.org"

gem "nokogiri"

group :development do
  gem "rspec"
  gem "yard"
  gem "bundler"
  gem "jeweler"
  gem "guard"
  gem "guard-rspec"
  gem "guard-bundler"
end

group :osx do
  # Needed for Guard to operate optimally on OSX
  platforms :mri do
    gem 'rb-fsevent'
    gem 'growl_notify'
  end
end
