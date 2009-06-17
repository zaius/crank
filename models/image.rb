class Image < Element
  before_save :resize, :if => Proc.new { |r| r.width_changed? or r.height_changed? }
  before_save :set_default_size_and_position, :if => Proc.new { |r| r.new_record? }

  super.register_suffixes Image, ['jpg', 'jpeg', 'gif', 'png']

  def display_html
    "<img src=\"/pages/#{self.page}/#{self.filename}\" />"
  end

  private

  def set_default_size_and_position
    max_width = max_height = 600
    # If it's a new record, we have to look up the ratio and scale it down 
    # to an acceptable size.
    # Strip is required to get rid of the console output's newline
    left, top = 500, 500
    width, height = (`identify -format "%w,%h" pages/#{page}/#{filename}`).strip.split(',')

    # Pictures could start off huge and unmanageable. Scale them down to 
    # something reasonable to start off with.
    # No need to call resize - it will get called because the width and 
    # height have changed.
    if width > max_width and height > max_height
      ratio = min(width / max_width, height / max_height)
      width, height *= ratio
    end
  end

  def resize
    `convert pages/#{page}/#{filename} -resize '#{width}x#{height}' public/pages/#{page}/#{filename}`
  end
end
