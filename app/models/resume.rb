class Resume < ActiveRecord::Base              
  #validates_format_of :content_type, :with => /^image/, 
  # :message => " you can only upload resumes" 
  belongs_to :user
    
  def resume=(resume_field)
    self.name = base_part_of(resume_field.original_filename)
    self.content_type = resume_field.content_type.chomp
    self.data = resume_field.read
  end
  
  def base_part_of(file_name)
    name = File.basename(file_name)
    name.gsub(/[^\w._-]/, '')
  end
end
