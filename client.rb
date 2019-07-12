#!/usr/bin/env ruby
$: << File.expand_path("#{File.dirname __FILE__}/lib")
require 'goosetune'
require 'yaml'
require 'pp'

goosetune = Goosetune::Youtube::Video.new
hash = {}

%w( 2016 ).each do |year|
  puts year
  # hash.merge!( goosetune.get_youtubes_by_year( year ) )
  goosetune.get_youtubes_by_year( year )
end

puts hash.to_yaml
