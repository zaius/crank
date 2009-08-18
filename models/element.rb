class Element 
  include DataMapper::Resource

  property :id,         Serial,   :nullable => false 
  property :page_name,  String,   :nullable => false 

  property :filename,   String,   :nullable => false 

  property :top,        Integer,  :nullable => false 
  property :left,       Integer,  :nullable => false 
  property :width,      Integer,  :nullable => false 
  property :height,     Integer,  :nullable => false 
  property :z_index,    Integer,  :nullable => false, :default => 0

  # Datamapper is causing a bunch of bugs when I declare this in the Textbox
  # model. Wasted a day on it already, so it's defined here until I can find
  # a better solution.
  # See bugs I've filed here:
  # http://datamapper.lighthouseapp.com/projects/20609/tickets/910-sti-lazy-text-validation-bug#ticket-910-1
  # http://datamapper.lighthouseapp.com/projects/20609-datamapper/tickets/911-sti-text-on-child-each-bug
  property :content, Text, :lazy => false

  property :created_at, DateTime
  property :updated_at, DateTime

  property :type,       Discriminator

  belongs_to :page

  @@suffix_mappings = []

  def self.get_element_child_for_suffix(suffix)
    @@suffix_mappings.each do |map|
      return map[:class] if map[:suffixes].include? suffix.downcase
    end
    throw 'No handler for suffix: ' + suffix
  end

  protected
  def self.register_suffixes(child_class, suffix_array)
    @@suffix_mappings << {
      :class => child_class, 
      # map trickery to get an array with every element downcased
      :suffixes => suffix_array.map(&:downcase)
    }
  end
end
