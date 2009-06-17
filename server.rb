#!/usr/bin/ruby
require 'environment'

@editing = false

get '/' do
  erb :main
end

get '/show/:page' do
  @elements = Element.all(:page => params[:page])

  erb :page, :layout => !request.xhr?
end

get '/edit/:page' do
  protected!

  refresh params[:page]

  @elements = Element.all(:page => params[:page])
  @editing = true
  erb :page
end

post '/save/:page' do
  protected!

  params[:images].each do |line|
    line = line.split ','

    id => line[0],
    attrs = {
      :width => line[1],
      :height => line[2],
      :left => line[3],
      :top => line[4]
    }

    element = Element.find(id)
    element.update_attributes(attrs)
  end

  "done"
end

get '/admin' do
  protected!

  Page.refresh
  @pages = Page.all
  erb :admin
end
