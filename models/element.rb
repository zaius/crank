class Element 
  include DataMapper::Resource

  property :id,         Serial,   :nullable => false 
  property :page_name,  String,   :nullable => false 

  property :filename,   String,   :nullable => false 

  property :top,        Integer,  :nullable => false 
  property :left,       Integer,  :nullable => false 
  property :width,      Integer,  :nullable => false 
  property :height,     Integer,  :nullable => false 

  property :created_at, DateTime
  property :updated_at, DateTime

  property :type,       Discriminator

  belongs_to :page

  @@suffix_mappings = []

  def self.get_element_child_for_suffix(suffix)
    @@suffix_mappings.each do |map|
      return map[:class] if map[:suffixes].include? suffix
    end
  end

  protected
  def self.register_suffixes(child_class, suffix_array)
    @@suffix_mappings << {:class => child_class, :suffixes => suffix_array}
  end
end
