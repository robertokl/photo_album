class ChangeLatOnPhotos < ActiveRecord::Migration
  def self.up
    change_column :photos, :lat, :string
    change_column :photos, :long, :string
  end

  def self.down
    change_column :photos, :lat, :float
    change_column :photos, :long, :float
  end
end
