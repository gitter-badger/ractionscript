# add current dir to ruby load path
$:.unshift File.dirname(__FILE__)

# load rake tasks
Dir["tasks/**/*.rake"].each { |ext| load ext } if defined?(Rake)

# dependencies
require 'rjb'
require 'ruby2ruby'
require 'sexp_template'
require 'sexp_builder'
require 'ruby_parser'

# internals
require 'ractionscript/dsl/translators/class_definition'
require 'ractionscript/dsl/translators/method_definition'
require 'ractionscript/dsl/translators/expression'
require 'ractionscript/dsl/generators/compilation_unit'
require 'ractionscript/dsl/generators/method_definition'
require 'ractionscript/dsl/generators/expression'
require 'ractionscript/dotvisuals'
require 'ractionscript/util'
require 'ractionscript/rjb'
Ractionscript::Rjb.load_metaas # must Rjb-import the metaas dependencies before 'constants' is loaded below
require 'ractionscript/constants'
require 'ractionscript/dsl/builder_context' # this uses Rjb so must be required after 'load_metaas'
require 'ractionscript/dsl'

# load a simple ractionscript source file sample and get it's ruby-syntax s-expression
ractionscript_source_file = File.join( File.dirname(__FILE__), 'ractionscript_simpletest.as3.rb' )
ractionscript_source      = File.read( ractionscript_source_file )

as3_source_code = Ractionscript::DSL.process( ractionscript_source )

puts "--------------------ActionScript--------------"
puts as3_source_code
puts "--------------------ActionScript--------------"

