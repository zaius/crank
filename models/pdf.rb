require 'models/image'

class Pdf < Image
  Element.register_suffixes self, ['pdf']

  def display_html
    "<img src=\"/pages/#{self.page.name}/#{self.image_filename}\" />"
  end

  def image_filename
    self.filename + '.jpg'
  end

  private

  def resize
    `convert pages/#{self.page.name}/#{self.filename} -resize '#{self.width}x#{self.height}' public/pages/#{self.page.name}/#{self.image_filename}`
  end
end
