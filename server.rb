#!/usr/bin/ruby
require 'rubygems'
require 'sinatra'
require 'erb'
require 'dm-core'

get '/' do
  erb :index
end

get '/screen' do
  output = ''
  File.open("screen.txt", "r").each_line do |line|
    # Strip required to get rid of the newlines
    src, width, height, left, top = line.strip.split(',')
    output << '<div class="image" style="' + 
      'width: ' + width + 'px; height:' + height + 'px; ' + 
      'position: absolute; left: ' + left + 'px; top: ' + top + 'px;' +
      '"><img src="' + src + '" /></div>'
  end

  return output
end

post '/save' do
  File.open('screen.txt', 'w') do |f|
    params.values.each do |line|
      f.print line.join(',') + "\n"
    end
  end

  return 'done'
end

get '/refresh' do
  directory = 'screen'

  old_tracked_files = File.open(directory + '.txt', 'r').each_line.map { |line| line.split(',') }
  directory_list = Dir.entries(directory).to_a
  new_tracked_files = []

  # delete references to any images that no longer exist
  old_tracked_files.each do |line|
    if directory_list.include? line[0]
      new_tracked_files << line
    end
  end

  # Add any new files
  missing_files = directory_list - new_tracked_files.map{|file| file[0]}
  missing_files.each do |file|
    # TODO: only use image files
    if file[0] == '.'[0]
      next
    end

    # Call imagemagick to get the size
    # strip is required to get rid of the newlines
    size = (`identify -format "%w,%h" #{directory}/#{file}`).strip.split(',')
    new_tracked_files << [directory + '/' + file, size[0], size[1], 500, 500]
  end

  # Write the new data out
  File.open(directory + '.txt', 'w') do |f|
    new_tracked_files.each do |line|
      f.print line.join(',') + "\n"
    end
  end

  # resize the files? what do i save filenames as?
  'done'
end
