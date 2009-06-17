class Page
  property :name, String, :key => true, :nullable => false 

  validates_presence_of :name
  validates_uniqueness_of :name

  has n, :elements
  has n, :images
  has n, :texts


  # Check for any new pages
  def self.refresh
    Page.remove_deleted_pages
    Page.add_new_pages
  end
  
  # Check for new elements on each page
  def refresh
    # If this is the first refresh, the image folder won't exist
    out_dir = "./public/pages/#{page}"
    FileUtils.mkdir_p(out_dir) unless File.directory?(out_dir)

    remove_deleted_files
    add_new_files
  end

  private
  def self.remove_deleted_pages
    Page.all.each do |p|
      p.destroy unless File.directory?(p)
    end
  end

  def self.add_new_pages
    new_pages = Dir.entries("pages").to_a
    new_pages.delete_if { |d| d.starts_with? '.' }
    new_pages.delete_if { |d| Pages.all.map(&:name).contains? d }

    # All remaining directories are new pages, insert them into the db
    new_pages.each do |d|
      FileUtils.mkdir_p(d)
      p = Page.create(:name => d)
      p.refresh
    end
  end

  def remove_deleted_elements
    elements.each do |e|
      e.destroy unless File.exists(e.filename)
    end
  end

  def add_new_elements
    new_elements = Dir.entries("pages/#{page}").to_a
    new_elements.delete_if { |d| d.starts_with? '.' }
    new_elements.delete_if { |d| Elements.all.map(&:filename).contains? d }
    new_elements.each do |d|
      # Get the class required to handle this suffix
      c = Element.get_element_child_for_suffix d.split('.').last
      c.create(:filename => d, :page => self)
    end
  end
end
