#!/usr/bin/env ruby

# simple util I am using for testing, just pass the name of a file containing ruby source and it gives the s-exp tree on stdout

require 'rubygems'
require 'ruby_parser'
require 'ap'

code = File.read(ARGV[0])
ap RubyParser.new.parse(code)

