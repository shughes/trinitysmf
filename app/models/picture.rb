require 'RMagick'
require 'ftools'

class Picture < ActiveRecord::Base
    validates_format_of :content_type, :with => /^image/,
    :message => "--- must be a picture"

    def picture=(picture_field)
        self.name = base_part_of(picture_field.original_filename)
        self.content_type = picture_field.content_type.chomp
        #self.data = picture_field.read
        img_dir = "#{RAILS_ROOT}/public/images/profiles"
        imgs = Magick::Image.from_blob(picture_field.read)
        img = imgs.first
        new_name = "#{img_dir}/#{self.name}.jpg"
        img.write(new_name) { self.quality = 50 }
        img = Magick::Image::read(new_name).first
        self.data = img.to_blob
        #File.delete(new_name)
    end

    def base_part_of(file_name)
        name = File.basename(file_name)
        name.gsub(/[^\w._-]/,'')
    end
end
