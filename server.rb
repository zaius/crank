#!/usr/bin/ruby
require 'rubygems'
require 'sinatra'
require 'environment'

@editing = false

# Any menu needs a list of pages - load for all actions
before do
  @pages = Page.all
end

get '/' do
  erb :main
end

get '/show/:page' do
  page = Page.get(params[:page])
  @elements = page.elements

  erb :page, :layout => !request.xhr?
end

get '/edit/:page' do
  protected!
  @editing = true

  @page = Page.get(params[:page])
  @page.refresh

  @elements = @page.reload.elements

  erb :page
end

post '/save/:page' do
  protected!

  params[:elements].each do |line|
    line = line.split ','

    e = Element.get line[0].split('_').last

    e.width = line[1]
    e.height = line[2]
    e.left = line[3]
    e.top = line[4]
    e.z_index = line[5]

    e.save
    raise "Error saving element: #{e.errors.inspect}" unless e.valid?
  end

  "done"
end

get '/admin' do
  protected!
  check_imagemagic_installed!

  Page.refresh

  erb :admin
end
