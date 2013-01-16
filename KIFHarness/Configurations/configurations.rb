#!/usr/bin/env ruby
require 'fileutils'

def verify_configuration_directory(directory)
  if !File.directory?(directory)
    puts "Error: The provided path is not a valid directory."
    exit
  end
end

def setup_merge_configuration(directory, force)
  path = directory + "Config-Merged.xcconfig"
  puts path
  if File.exists?(path) && !force
    puts "Error: Config-Merged.xcconfig already exists at the provided path."
    exit
  else
    File.open(path, 'w') { |file| file.write("//
//  Config-Merged.xcconfig
//
//  Created by Jerry Jones on 1/15/13.
//  Copyright (c) 2013 Spaceman Labs, Inc. All rights reserved.
//
// This file was generated using the Spaceman Labs Configuration Tool




// **** DO NOT DIRECTLY MODIFY THIS FILE ****") }
  end
end


def merge_files(directory, files)
  merge_path = directory + "Config-Merged.xcconfig"
  puts "remove file: " + merge_path
  out_file = File.open(merge_path, 'w')
  
  files.each do |path|
    inputPath = nil
    localPath = directory + path
    if File.exists?(path)
      puts "Merging config: " + path
      inputPath = path
    elsif File.exists?(localPath)
      puts "Merging config: " + localPath
      inputPath = localPath
    else
      puts "Invalid File. NOT Merging config: " + path
    end
    
    if inputPath
      out_file << "//
// **** Added By Configurations.rb ****
// **** Path: " + path + " ****
//\n\n"

      out_file << File.open(inputPath, 'r').read
      
    end
  end
  
  out_file.close
  
end

def show_usage
  base_name = File.basename(__FILE__)
  puts "Usage:"
  puts "      ruby #{base_name} --setup configuration_directory\n"
  puts "      ruby #{base_name} --merge xcconfig_file configuration_directory\n"
  puts "      ruby #{base_name} --reset configuration_directory\n"
end

if ARGV.length == 0
  show_usage
  exit
end

last_arg = ARGV.last.to_s.downcase
first_arg = ARGV.first.to_s.downcase
middle_args = nil

if ARGV.count > 2
  middle_args = ARGV[1, ARGV.count - 2]
end

verify_configuration_directory(last_arg)
last_arg = last_arg.sub!(/[\/]*$/, '') + "/"

if first_arg == "--setup"
  setup_merge_configuration(last_arg, false)
elsif first_arg == "--merge"
  if middle_args.to_a.count == 0
    puts "Error: No provided configurations to merge"
    exit
  end
  
  merge_files(last_arg, middle_args)
  
elsif first_arg == "--reset"
  setup_merge_configuration(last_arg, true)
end