source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"
gem 'sequel'

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "bundler", "~> 1.0.0"
  gem "jeweler", "~> 1.5.2"
  gem "rcov", ">= 0"
  gem "test-unit"

  if RUBY_PLATFORM == 'java'
    gem 'jdbc-sqlite3'
  else
    gem 'sqlite3'
  end
end
