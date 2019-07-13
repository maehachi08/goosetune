#!/usr/bin/env ruby
$: << File.expand_path("#{File.dirname __FILE__}/lib")
require 'goosetune'
require 'yaml'
require 'pp'

client = Goosetune::Youtube::Video.new(youtube_channnel_id='UCx66obAJ42B0XwHIm_iupkw')
response = client.get_youtubes_by_year('2019')
puts response.to_yaml

