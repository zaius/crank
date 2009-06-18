#!/usr/bin/ruby
require 'erb'
# Use the helpers.rb file for authentication methods
require 'helpers'

# Connect to the DB, load up the models
require 'dm-core'
require 'dm-validations'

DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/content.db")
Dir.glob('./models/*.rb').each {|f| require f }

DataMapper.auto_upgrade!
