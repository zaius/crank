class Element 
  include DataMapper::Resource

  property :id,         Serial,   :nullable => false 
  property :page,       String,   :nullable => false 

  property :filename,   String,   :nullable => false 

  property :top,        Integer,  :nullable => false 
  property :left,       Integer,  :nullable => false 
  property :width,      Integer,  :nullable => false 
  property :height,     Integer,  :nullable => false 

  property :created_at, DateTime, :nullable => false 
  property :updated_at, DateTime, :nullable => false 

  belongs_to :page

  @@suffix_mappings = []

  def get_element_child_for_suffix(suffix)
    @@suffix_mappings.each do |map|
      return map[:class] if map[:suffixes].contains? suffix
    end
  end

  protected
  def self.register_suffix(child_class, suffix_array)
    @@suffix_mappings << {:class => child_class, :suffixes => suffix_array}
  end
end
