class Textbox < Element
  property :content, Text, :lazy => false

  # Can't do not-null checks on the property because this is single table
  # inheritance, and it can't be enforced on other types. Therefore, have to
  # do model level checks.
  validates_present :content

  before :save do
    set_default_size_and_location if self.new_record?
    get_content_from_file
  end

  Element.register_suffixes self, ['txt', 'text']

  def display_html
    self.content
  end

  private

  def get_content_from_file
    self.content = File.open("pages/#{self.page.name}/#{self.filename}").collect.join
  end

  def set_default_size_and_location
    self.width = 500
    self.height = 200
    self.top = 500
    self.left = 500
  end
end
