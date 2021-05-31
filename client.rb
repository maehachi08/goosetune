#!/usr/bin/env ruby
$: << File.expand_path("#{File.dirname __FILE__}/lib")
require 'goosetune'
require 'yaml'
require 'pp'

goosehouse = 'UCFDL0NuxUBAvvu1PnIwW2ww'
pyaygoose = 'UCx66obAJ42B0XwHIm_iupkw'
client = Goosetune::Youtube::Video.new(youtube_channnel_id=goosehouse)
response = client.get_youtubes
puts response.to_yaml

