helpers do
  def protected!
    response['WWW-Authenticate'] = %(Basic realm="Testing HTTP Auth") and \
      throw(:halt, [401, "Not authorized\n"]) and \
      return unless authorized?
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'people']
  end

  def check_imagemagic_installed!
    if `identify`.include? 'not found' or `convert`.include? 'not found' 
      throw 'ImageMagick convert/identify not installed or not in path'
    end
  end
end

class String
  def starts_with?(prefix)
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end

  def ends_with?(suffix)
    suffix = suffix.to_s
    self[-suffix.length, suffix.length] == suffix      
  end
end

module Math
  def self.max(a, b)
    a > b ? a : b
  end

  def self.min(a, b)
    a < b ? a : b
  end
end

class Symbol
  def to_proc
    Proc.new { |*args| args.shift.__send__(self, *args) }
  end
end
