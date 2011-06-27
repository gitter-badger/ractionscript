# add current dir to ruby load path
$:.unshift File.dirname(__FILE__)

# dependencies
require 'rjb'
require 'ruby2ruby'
require 'sexp_template'
require 'sexp_builder'
require 'ruby_parser'

# internals
require 'ractionscript/dsl/translators/class_definition'
require 'ractionscript/dsl/translators/method_definition'
require 'ractionscript/dsl/translators/post_processor'
require 'ractionscript/dsl/generators/compilation_unit'
require 'ractionscript/dsl/generators/method_definition'
require 'ractionscript/dotvisuals'
require 'ractionscript/util'
require 'ractionscript/rjb'
Ractionscript::Rjb.load_metaas # must Rjb-import the deps before 'constants' is loaded
require 'ractionscript/constants'

# temporary for development
require 'awesome_print'

# NOTE
# currently all this does is run your ractionscript source's ruby-syntax s-expression
# through ractionscript's 'translator' which should decide
# what's ruby and what's actionscript-generating-dsl

# load a simple ractionscript source file sample and get it's ruby-syntax s-expression
ractionscript_source_file = File.join( File.dirname( __FILE__ ) , 'ractionscript_simpletest.as3.rb' )
ractionscript_source = File.read( ractionscript_source_file )
sexp = Ractionscript::Sexp.ruby_string_to_sexp ractionscript_source 

# for development, display it in graphviz and highlight a matching subexpression
system "killall rsvg-view"  # temp, convenient for me

highlight = Q?{
            all(
              child(s(:ras, :method_definition, _, _)),
              t(:block)
            ) % :highlight
}
#Ractionscript::Sexp.viz_sexp sexp, highlight

# translate the ruby-syntax s-expression
# rewriting the parts that are meant to become actionscript
# leaving the rest untouched
# start from the highest level scope of ractionscript syntax (class definition)
# work down the scope rules
# reason is that SexpBuilder wont rewrite s-expressions within rewritten ones
# so it has to be a chain
sexp = Ractionscript::DSL::Translators::ClassDefinition.new.process(sexp)
sexp = Ractionscript::DSL::Translators::MethodDefinition.new.process(sexp)
#Ractionscript::Sexp.viz_sexp sexp, highlight
sexp = Ractionscript::DSL::Translators::PostProcessor.new.process(sexp)
#Ractionscript::Sexp.viz_sexp sexp, highlight

# translate the ractionscript s-expression to a ruby ast s-expression which will build actionscript ast with metaas java classes
sexp = Ractionscript::DSL::Generators::CompilationUnit.new.process(sexp)
#Ractionscript::Sexp.viz_sexp sexp, highlight
sexp = Ractionscript::DSL::Generators::MethodDefinition.new.process(sexp)
Ractionscript::Sexp.viz_sexp sexp, highlight

# back to ruby source string
sourcebuilder = Ruby2Ruby.new.process( sexp )

puts "--------------------source builder--------------"
puts sourcebuilder
puts "--------------------source builder--------------"

# a context class which has the necessary java type constants
class BuilderContext
  include Ractionscript::JavaTypes::MetaAs
end

# define our sourcebuilder as an instance method 'metacompile'
BuilderContext.class_eval(sourcebuilder)

# make one do it's thing
bc = BuilderContext.new
unit = bc.metacompile

# 'metacompile' returned an Rjb instance of the compilation-unit class from metaas

# we need a java stringwriter instance to make 'unit' do it's thing
sw = Ractionscript::JavaTypes::Util::StringWriter.new
Ractionscript::AST::Factory.newWriter.write(sw, unit)

# output some actual valid ActionScript code (we hope)
puts "--------------------ACTIONSCRIPT FUCK YEAH--------------"
puts sw.toString
puts "--------------------ACTIONSCRIPT FUCK YEAH--------------"

