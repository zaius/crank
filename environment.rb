#!/usr/bin/ruby
require 'erb'
# Use the helpers.rb file for authentication methods
require 'helpers'

# Connect to the DB, load up the models
require 'dm-core'
require 'dm-validations'

DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/content.db")
require 'models/page'
require 'models/element'
require 'models/image'
require 'models/flash'
require 'models/pdf'
require 'models/textbox'

DataMapper.auto_upgrade!
