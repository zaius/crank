class Text < Element
  property :value, String, :nullable => false 

  validates_presence_of :value
  before_save :get_value_from_file
  before_save :set_default_size_and_location, :if => Proc.new { |r| r.new_record? }

  super.register_suffixes Image, ['txt', 'text']

  def display_html
    "<div>#{value}</div>"
  end

  private

  def get_value_from_file
    self.value = File.open(self.filename).collect.join
  end

  def set_default_size_and_location
    self.width = 500
    self.height = 200
    self.top = 500
    self.left = 500
  end
end
