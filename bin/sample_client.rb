#!/usr/bin/env ruby
$: << File.expand_path("#{File.dirname __FILE__}/../lib")
require 'goosetune'
require 'yaml'
require 'optparse'

years = %w(2010 2011 2012 2013 2014 2015)
data = {}
begin
  option = {}
  opt = OptionParser.new do |opt|
    opt.banner = "Usage: #{$0} [option]"
    opt.on('-t youtube/ustream',		'対象')	{|v| option[:type] = v}
    opt.on('-m videos/view_counts',	'内容')	{|v| option[:method] = v}
  end
  opt.parse!(ARGV)
  
  case option[:type]
  when 'youtube'
    goosetune = Goosetune::Youtube::Video.new
  
    case option[:method]
    when 'videos'
      years.each do |year|
        goosetune = Goosetune::Youtube::Video.new
	data.merge!(goosetune.get_youtubes_by_year(year))
      end
    when 'view_counts'
      years.each do |year|
        goosetune = Goosetune::Youtube::Video.new
	data.merge!(goosetune.get_view_counts_by_year(year))
      end
    else
      raise OptionParser::ParseError
    end
  when 'ustream'
    goosetune = Goosetune::Ustream::Video.new
  
    case option[:method]
    when 'videos'
      puts goosetune.get_ustreams.to_yaml
    when 'view_counts'
      puts goosetune.get_view_counts.to_yaml
    else
      raise OptionParser::ParseError
    end
  else
    raise OptionParser::ParseError
  end

  puts data.to_yaml

rescue OptionParser::ParseError
  puts opt.help
  exit
end
