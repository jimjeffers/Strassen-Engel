class AddSlug < ActiveRecord::Migration
  def self.up
    add_column :districts, :slug, :string
  end

  def self.down
    remove_column :districts, :slug
  end
end