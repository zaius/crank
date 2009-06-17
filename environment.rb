#!/usr/bin/ruby
require 'rubygems'
require 'sinatra'
require 'erb'
# Use the helpers.rb file for authentication methods
require 'helpers'

# Connect to the DB, load up the models
require 'dm-core'
DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/content.db")
Dir.glob('/models/*.rb').each {|f| require f }

DataMapper.auto_upgrade!

set :app_file, 'server.rb'
set :reload, true
