class Page
  include DataMapper::Resource

  property :name, String, :key => true, :nullable => false 

  has n, :elements
  has n, :images
  has n, :textboxes


  # Check for any new pages
  def self.refresh
    Page.remove_deleted_pages
    Page.add_new_pages
  end
  
  # Check for new elements on each page
  def refresh
    # If this is the first refresh, the image folder won't exist
    out_dir = "./public/pages/#{self.name}"
    FileUtils.mkdir_p(out_dir) unless File.directory?(out_dir)

    remove_deleted_elements
    add_new_elements
  end

  private
  def self.remove_deleted_pages
    Page.all.each do |p|
      p.destroy unless File.directory?("pages/#{p.name}")
    end
  end

  def self.add_new_pages
    new_pages = Dir.entries("pages").to_a
    new_pages.delete_if { |d| d.starts_with? '.' }
    new_pages.delete_if { |d| Page.all.map(&:name).include? d }

    # All remaining directories are new pages, insert them into the db
    new_pages.each do |d|
      p = Page.create!(:name => d)
      p.refresh
    end
  end

  def remove_deleted_elements
    elements.each do |e|
      e.destroy unless File.exists?("pages/#{self.name}/#{e.filename}")
    end
  end

  def add_new_elements
    new_elements = Dir.entries("pages/#{self.name}").to_a
    new_elements.delete_if { |f| f.starts_with? '.' }
    new_elements.delete_if { |f| self.elements.map(&:filename).include? f }
    new_elements.each do |d|
      # Get the class required to handle this suffix
      c = Element.get_element_child_for_suffix d.split('.').last
      c.create!(:filename => d, :page => self)
    end
  end
end
