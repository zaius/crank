class Textbox < Element
  # The Content property is specific to this Textbox class, but it's causing
  # no end of problems. See element.rb for more info.
  #
  # Can't do not-null checks on the property because this is single table
  # inheritance, and it can't be enforced on other types. Therefore, have to
  # do model level checks.
  validates_present :content

  before :valid? do
    set_default_size_and_location if self.new?
    get_content_from_file
  end

  Element.register_suffixes self, ['txt', 'text']

  def display_html
    self.content
  end

  private

  def get_content_from_file
    self.content = File.read "pages/#{self.page.name}/#{self.filename}"
  end

  def set_default_size_and_location
    self.width = 500
    self.height = 200
    self.top = 500
    self.left = 500
  end
end
