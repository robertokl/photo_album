class Album < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :photos

  def <=> otherAlbum
    self.name <=> otherAlbum.name
  end

  alias ar_save save

  def save
    FileUtils.mkdir_p "public/images/#{self.name}"
    FileUtils.mkdir_p "public/images/#{self.name}/cache"
    ar_save
  end

  def check_ftp
    images = Dir.new "public/images/#{self.name}"
    puts "public/images/#{self.name}"
    images.each do |i|
        next if file_is_not_jpg i
        p = Photo.new :album => self, :title => i[0..(i.length - 5)]
        puts p.save
        p.errors.each {|a,b| puts a + "-" + b}
    end
  end

  def file_is_not_jpg file_name
    file_name.match(/.jpg$/i).nil?
  end
end
