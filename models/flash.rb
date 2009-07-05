class Flash < Element
  before :save do
    set_default_size_and_position if self.new_record?
    copy_file
  end

  Element.register_suffixes self, ['swf']

  def display_html
    path = '/pages/' + self.page.name + '/' + self.filename

    # The 'standard' monster flash embed code. Courtesy of:
    # http://www.alistapart.com/articles/flashsatay/
    # Couldn't be fucked doing the double load thing. Good luck with validation!
    '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" 
      codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" 
      width="100%" height="100%" id="movie" align="">
    <param name="movie" value="' + path + '">
    <embed src="' + path + '" quality="high" 
      width="100%" height="100%" name="movie" align="" 
      type="application/x-shockwave-flash" 
      pluginspage="http://www.macromedia.com/go/getflashplayer" />
    </object>'
  end

  private

  # For once, flash is the easiest. No processing required - just copy!
  def copy_file
    `cp pages/#{self.page.name}/#{self.filename} public/pages/#{self.page.name}/#{self.filename}`
  end

  def set_default_size_and_position
    self.left, self.top = 500, 500
    # No way to determine the size. Guess a 4:3 ratio
    self.width, self.height = 400, 300
  end
end
