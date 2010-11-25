class Article < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :name
      t.text :content
      t.references :district
      t.string :avatar_file_name
      t.string :avatar_content_type
      t.integer :avatar_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
