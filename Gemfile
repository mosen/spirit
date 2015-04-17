source 'https://rubygems.org'

# Distribute your app as a gem
# gemspec

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Optional JSON codec (faster performance)
# gem 'oj'

# Project requirements
gem 'rake'

# Component requirements
gem 'slim'
gem 'sqlite3'
gem 'activerecord', :require => "active_record"

# Test requirements

# Padrino Stable Gem
gem 'padrino', '0.12.4'

# Sinatra-contrib for YAML config
gem 'sinatra-contrib', '1.4.2'

# Required for parsing and constructing plists
gem 'CFPropertyList', '2.3.1'

# Announce deploystudio service on local subnet
gem 'dnssd', '2.0.1'

group :test do
  # To run RSpec against padrino
  gem 'rspec-padrino'

  # Generate RSpec fixtures
  gem 'factory_girl'

  # Used to fake an existing DS repository in RSpec examples.
  gem 'fakefs', :require => "fakefs/safe"
end