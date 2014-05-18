require 'rubygems'
require 'bundler'

Bundler.require

$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'wikipedia-random-walk'

if ARGV.empty?
  warn "usage: bundle exec sample.rb (KEYWORD)"
end

KEYWORD = ARGV.first

walker = WikipediaRandomWalker.new(KEYWORD)

walker.each{|keyword|
  puts keyword
}
