class Photo < ActiveRecord::Base

  validates_presence_of :title
  validates_uniqueness_of :title
  belongs_to :album
  validates_associated :album

  def <=> otherPhoto
    self.title <=> otherPhoto.title
  end

  def file= file
    @file = file
  end

  def file
    @file
  end

  alias ar_save save

  def save
    if self.title.blank? && self.file.blank?
      errors.add(:file, "Obrigatorio.")
      return false
    end
    self.title = self.file.original_filename[0..(self.file.original_filename.length - 5)] if self.title.empty?
    File.open(file_path, "wb") { |f| f.write(self.file.read) } unless self.file.blank?
    ar_save
  end
  
  alias ar_destroy destroy

  def destroy
    File.delete find_file.path
    ar_destroy
  end
  
  def find_file
    path = "public/images/#{self.album.name}/"
    dir = Dir.new path
    dir.each {|d| return File.open "#{path}#{d}" unless d.match(/^#{self.title}/).nil?}
  end

  def file_path
    find_file.path
  end

  def image_path
    find_file.path.gsub "public/images/", ""
  end

  def file_name
    a = find_file.path.gsub "public/images/#{self.album.name}/", ""
    puts a
    a
  end

end
