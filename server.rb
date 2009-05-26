#!/usr/bin/ruby
require 'rubygems'
require 'sinatra'
require 'erb'
require 'dm-core'
# Use the helpers.rb file for authentication methods
require 'helpers'

set :app_file, __FILE__
set :reload, true

DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/content.db")

class Image
  include DataMapper::Resource
  property :id,         Serial
  property :page,       String
  property :original_filename,   String
  property :filename,   String
  property :top,        Integer
  property :left,       Integer
  property :width,      Integer
  property :height,     Integer
  property :created_at, DateTime
end

DataMapper.auto_migrate!
@editing = false

get '/' do
  erb :main
end

get '/show/:page' do
  @images = Image.all(:page => params[:page])

  erb :images, :layout => !request.xhr?
end

get '/edit/:page' do
  protected!

  @page = params[:page]
  refresh(@page) if needs_refresh?(@page)

  @images = Image.all(:page => params[:page])
  @editing = true
  erb :images
end

post '/save/:page' do
  protected!


  params[:images].each do |line|
    line = line.split ','
    attrs = {
      :page => params[:page],
      :filename => line[0].split('/').last,
      :width => line[1],
      :height => line[2],
      :left => line[3],
      :top => line[4]
    }

    image = Image.first(:page => attrs[:page], :filename => attrs[:filename])
    image.update_attributes(attrs)

    # get imagemagick to resize all the images to their new sizes
    `convert images/#{image.page}/#{image.original_filename} -resize '#{image.width}x#{image.height}' public/images/#{image.page}/#{image.filename}`
  end

  "done"
end

get '/admin' do
  protected!

  @pages = Dir.entries("images").to_a.reject {|x| x.starts_with? '.'}
  erb :admin
end



# Checks if the images in the database are in sync with the images in the 
# directory. This allows the user to add / remove files.
def needs_refresh?(page)
  images = Image.all(:page => page).map {|i| i.filename}
  files  = Dir.entries("images/#{page}").to_a
  images.sort != files.sort
end

def refresh(page)
  images = Image.all(:page => page)
  directory_list = Dir.entries("images/#{page}").to_a
  directory_list -= ['.', '..']

  # delete references to any images that no longer exist
  images.each do |image|
    unless directory_list.include? image.filename
      image.destroy
    end
  end

  # Add any new files
  new_files = directory_list - images.map {|i| i.original_filename}
  new_files.each do |input_file|
    # TODO: deal with multi page pdfs
    if input_file.ends_with? '.pdf'
      output_file = input_file[0..-4] + 'jpg'
    else
      output_file = input_file
    end
    

    # If this is the first refresh, the image folder won't exist
    out_dir = "./public/images/#{page}"
    FileUtils.mkdir_p(out_dir) unless File.directory?(out_dir)

    # any new files dropped in are probably going to be massive - reduce them
    # to a more manageable size
    `convert images/#{page}/#{input_file} -resize '600x450>' public/images/#{page}/#{output_file}`

    # But, that doesn't return any size info to us. Need to call imagemagick
    # again to check the actual size
    # Strip is required to get rid of the console output's newline
    width, height = (`identify -format "%w,%h" public/images/#{page}/#{output_file}`).strip.split(',')

    Image.create(
      :page => page,
      :original_filename => "#{input_file}",
      :filename => "#{output_file}",
      :width => width,
      :height => height,
      :left => 500,
      # TODO: put this below the lowest image
      :top => 500
    )
  end
end
