#!/usr/bin/env ruby

# Directions:
# sudo gem install bundler
# sudo bundle install
# ruby build.rb

require "rubygems"
require "bundler"
Bundler.setup

require "ruby-growl"
require "directory_watcher"
require "yui/compressor"
require "asset_build/css_reader"
require "asset_build/css_reader"

# --------------------------------------------------------------
# Path Constants

JS_PATH                 = "./public/javascripts/"
COFFEE_PATH             = "./public/coffee/"
STYLES_PATH             = "./public/stylesheets/"
CSS_PATH                = "./public/css/"
JS_DEPENDENCIES         = ['jquery-1.4.3.min.js','modernizr-1-2.5.min.js']

# --------------------------------------------------------------
# Filename Constants

CSS_SOURCE_FILENAME     = "_master.css"
CSS_OUTPUT_FILENAME     = "master.build.min.css"

# --------------------------------------------------------------
# Script Start

puts "---------------------------------------------\nAuto-regenerating enabled."

# --------------------------------------------------------------
# Setup growl notifications.
g = Growl.new "127.0.0.1", "build-growl", ["build-growl Notification"]
g.notify "build-growl Notification", "Build Script Initializing", "Checking for Coffee and CSS in Project"
         
# --------------------------------------------------------------
# Watch for build for Coffee/JS files.
coffee_directory_watcher = DirectoryWatcher.new('.')
coffee_directory_watcher.interval = 1
coffee_directory_watcher.glob = Dir.glob("#{COFFEE_PATH}**/*.coffee")
coffee_directory_watcher.add_observer do |*args|
  
  # Nice output for our users.
  puts "\n[#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}] [COFFEE] Regeneration: #{args.size} files changed"
  puts "\n[JS]     Bundling coffee scripts to:\n         #{JS_PATH}app.js"
  
  # Define the paths to our target javascript file and precompiled coffeescript.
  coffee_path     = JS_PATH+'app.coffee'
  javascript_path = JS_PATH+'app.js'
  minified_path   = JS_PATH+'app.min.js'
  
  # Merge all of our coffee files to the coffee_path
  File.open(coffee_path,'w') {|f| f.write Dir.glob(File.join(Dir.pwd,COFFEE_PATH+'**/*.coffee')).map{ |path| %x(cat #{path}) }.join("\n\n") }
  
  # Generate javascript with coffeescript's compiler.
  javascript = %x(coffee -p #{coffee_path})
  
  # Provide feedback to our user that we're generating documentation for the coffeescripts.
  puts "\n[DOCCO]  Regenerating documentation in:\n        ./docs"
  
  # Execute docco on the directory.
  `docco #{COFFEE_PATH}**/*`
  
  if JS_DEPENDENCIES and JS_DEPENDENCIES.length > 0
    dependency_dump = ""
    JS_DEPENDENCIES.each do |dependency|
      dependency_dump += File.open(JS_PATH+dependency,'r').readlines.join("\n")
    end
    javascript = dependency_dump + javascript
  end
  
  # Write the generated JS and minified counterpart to the project.
  File.open(javascript_path,'w') {|f| f.write javascript }
  File.open(minified_path,'w') {|f| f.write YUI::JavaScriptCompressor.new().compress(javascript) }
  
  # Clean up the merged coffee file.
  File.delete(coffee_path)
  puts "\n[COFFEE] Build complete! Listening for further changes.\n[CTRL-C to terminate]\n---------------------------------------------"
  g.notify  "build-growl Notification", "Coffee Build Complete", 
            "Regenerating documentation in: ./docs\nBundling coffee scripts to: #{JS_PATH}app.js"
end
coffee_directory_watcher.start

# Watch for build with CSS files.
stylesheet_directory_watcher = DirectoryWatcher.new('.')
stylesheet_directory_watcher.interval = 1
stylesheet_directory_watcher.glob = Dir.glob(STYLES_PATH+"*.css")
stylesheet_directory_watcher.add_observer do |*args|
  puts "\n[#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}] [CSS] Regeneration: #{args.size} files changed"
  puts "\n[CSS]    Processing #{STYLES_PATH} #{CSS_SOURCE_FILENAME} to:\n        #{CSS_PATH}#{CSS_OUTPUT_FILENAME}"
  origin_path = STYLES_PATH+CSS_SOURCE_FILENAME
  output_path = CSS_PATH+CSS_OUTPUT_FILENAME
  CSSReader.new(origin_path).save(output_path,:compress => true)
  puts "\n[CSS] Build complete! Listening for further changes.\n[CTRL-C to terminate]\n---------------------------------------------"
  g.notify  "build-growl Notification", "CSS Build Complete", 
            "Processing #{STYLES_PATH} #{CSS_SOURCE_FILENAME} to: #{CSS_PATH}#{CSS_OUTPUT_FILENAME}"
end
stylesheet_directory_watcher.start

# Loop until we capture an interception from the user.
x = 0
trap("SIGINT") do
  puts "\n\n---------------------------------------------\nTerminating..."
  x = 1
end
until x==1
  sleep 1
end