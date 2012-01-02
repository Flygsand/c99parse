require 'rubygems'
require 'bundler/setup'

require 'rspec'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'transform'