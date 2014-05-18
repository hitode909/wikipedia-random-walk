require 'rubygems'
require 'bundler'

Bundler.require

$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'wikipedia-random-walk'

KEYWORD = ARGV.first

walker = WikipediaRandomWalker.new(KEYWORD)

walker.each{|keyword|
  puts keyword
}
