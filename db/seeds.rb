# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


["Charlottenburg","Friedrichshain","Hellersdorf","Hohensomonhausen","Lichtenberg","Kopenick","Kreuzberg","Marzahn","Mitte","Neukolln",
"Pankow","Prenzlauer Berg","Reinickendorf","Schoneberg","Spandau","Steglitz","Tempelhof","Tiergarten",
"Treptow","Wedding","Weissensee","Wilmersdorf","Zehlendorf"].each do |name|
  District.find_by_name(name).destroy if !District.find_by_name(name).nil?
  District.create(:name => name, :city => "Berlin", :slug => name.gsub(' ','_').downcase) if District.find_by_name(name).nil?
  puts "Generating district: #{name}"
end

