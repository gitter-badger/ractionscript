# add current dir to ruby load path
$:.unshift File.dirname(__FILE__)

load "tasks/ractionscript.rake" if defined?(Rake)

# dependencies
require 'rjb'
require 'ruby2ruby'
require 'sexp_template'
require 'sexp_builder'
require 'ruby_parser'

# internals
require 'ractionscript/dotvisuals'
require 'ractionscript/util'
require 'ractionscript/rjb'
Ractionscript::Rjb.load_metaas # must Rjb-import the metaas dependencies before 'constants' is loaded below
require 'ractionscript/constants'
require 'ractionscript/dsl/builder_context' # this uses Rjb so must be required after 'load_metaas'
require 'ractionscript/dsl'
