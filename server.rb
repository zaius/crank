#!/usr/bin/ruby
require 'rubygems'
require 'sinatra'
require 'environment'

@editing = false

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

  @elements = @page.elements

  erb :page
end

post '/save/:page' do
  protected!

  params[:images].each do |line|
    line = line.split ','

    id = line[0]
    attrs = {
      :width => line[1],
      :height => line[2],
      :left => line[3],
      :top => line[4]
    }

    element = Element.get(id)
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
