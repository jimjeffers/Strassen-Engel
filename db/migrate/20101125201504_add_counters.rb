class AddCounters < ActiveRecord::Migration
  def self.up
    add_column :districts, :articles_count, :integer
    add_column :users, :articles_count, :integer
  end

  def self.down
    remove_column :users, :articles_count
    remove_column :districts, :articles_count
  end
end