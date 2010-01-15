class Image < Element
  before :valid? do
    set_default_size_and_position if self.new?
    resize if self.attribute_dirty?(:width) or self.attribute_dirty?(:height)
  end

  Element.register_suffixes self, ['jpg', 'jpeg', 'gif', 'png', 'tif', 'tiff']

  def display_html
    "<img src=\"/pages/#{self.page.name}/#{self.filename}\" />"
  end

  private

  def set_default_size_and_position
    max_width = 600
    max_height = 600
    # If it's a new record, we have to look up the ratio and scale it down 
    # to an acceptable size.
    # Strip is required to get rid of the console output's newline
    self.left, self.top = 500, 500
    self.width, self.height = (`identify -format "%w,%h" pages/#{self.page.name}/#{self.filename}`).strip.split(',')

    # Pictures could start off huge and unmanageable. Scale them down to 
    # something reasonable to start off with.
    # No need to call resize - it will get called because the width and 
    # height have changed.
    if self.width > max_width or self.height > max_height
      # Calculate the ratio to multiply both width and height by that will end
      # up with an image smaller than the maximum dimensions. Note that this
      # must have floating point conversions, as ratio is always > 0 and < 1
      ratio = Math.min(max_width.to_f / self.width, max_height.to_f / self.height)
      self.width = (self.width * ratio).to_i
      self.height = (self.height * ratio).to_i
    end
  end

  def resize
    `convert pages/#{self.page.name}/#{self.filename} -resize '#{self.width}x#{self.height}' public/pages/#{self.page.name}/#{self.filename}`
  end
end
