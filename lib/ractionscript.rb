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
require 'ractionscript/dsl/translators/expression'
require 'ractionscript/dsl/translators/post_processor'
require 'ractionscript/dsl/generators/compilation_unit'
require 'ractionscript/dsl/generators/method_definition'
require 'ractionscript/dsl/generators/expression'
require 'ractionscript/dotvisuals'
require 'ractionscript/util'
require 'ractionscript/rjb'
Ractionscript::Rjb.load_metaas # must Rjb-import the metaas dependencies before 'constants' is loaded below
require 'ractionscript/constants'

# FIXME temporary for development
require 'awesome_print'

# NOTE
# currently all this does is run your ractionscript source's ruby-syntax s-expression
# through ractionscript's translators which should decide
# what's ruby and what's actionscript-generating-dsl
# then passes that through the generators
# which produces ruby code calling metaas through Rjb to produce ActionScript source

# load a simple ractionscript source file sample and get it's ruby-syntax s-expression

ractionscript_source_file = File.join( File.dirname(__FILE__), 'ractionscript_simpletest.as3.rb' )

ractionscript_source = File.read( ractionscript_source_file )

sexp = Ractionscript::Sexp.ruby_string_to_sexp( ractionscript_source )

# for development, display it in graphviz and highlight a matching subexpression
system "killall rsvg-view"  # temp, convenient for me

highlight = Q?{
  s(:ras,
    :expression,
    _ ) % :highlight
}

# translate the ruby-syntax s-expression
# rewriting the parts that are meant to become actionscript
# leaving the rest untouched
# start from the highest level scope of ractionscript syntax (class definition)
# work down the scope rules
# reason for splitting translators into many classes is twofold
# 1) separation of concerns, potentially help make this a part of a generic library ruby-babel
# 2) SexpBuilder is not recursive, i.e. it wont rewrite s-expressions within rewritten ones
# so it is a chain of SexpBuilders (translators)

# to visualize it anywhere along the way insert this between calls to translators or generators 'process'
#Ractionscript::Sexp.viz_sexp sexp, highlight

sexp = Ractionscript::DSL::Translators::ClassDefinition.new.process(sexp)

sexp = Ractionscript::DSL::Translators::MethodDefinition.new.process(sexp)

sexp = Ractionscript::DSL::Translators::Expression.new.process(sexp)

sexp = Ractionscript::DSL::Translators::PostProcessor.new.process(sexp)

# now generators...
# at this point 'sexp' is not a valid ruby AST, it has a bunch of ractionscript specific things
# the generators convert this to a ruby AST
# which will build ActionScript AST with metaas Java classes

sexp = Ractionscript::DSL::Generators::CompilationUnit.new.process(sexp)

sexp = Ractionscript::DSL::Generators::MethodDefinition.new.process(sexp)

sexp = Ractionscript::DSL::Generators::Expression.new.process(sexp)

Ractionscript::Sexp.viz_sexp(sexp, highlight);# exit(0)


# back to ruby source string
sourcebuilder = Ruby2Ruby.new.process( sexp )

puts "--------------------source builder--------------"
puts sourcebuilder
puts "--------------------source builder--------------"

# now define a context class which has the necessary java type constants
# sourcebuilder will be eval'd with self being BuilderContext
# TODO BuilderContext could do more, the stuff in 'sourcebuilder' could be simplified
# and the swizzling of method and class modifiers could be done away with

class BuilderContext
  include Ractionscript::JavaTypes::MetaAs
end

# sourcebuilder defines an instance method 'metacompile' on BuilderContext

BuilderContext.class_eval(sourcebuilder)

# and now...

bc = BuilderContext.new

compilation_unit = bc.metacompile

# 'metacompile' has returned an Rjb instance of the metaas compilation-unit class
# we need a Java StringWriter instance to make 'compilation_unit' do it's thing

sw = Ractionscript::JavaTypes::Util::StringWriter.new

Ractionscript::AST::Factory.newWriter.write(sw, compilation_unit)

# output some actual valid ActionScript code (we hope)

puts "--------------------ACTIONSCRIPT FUCK YEAH--------------"
puts sw.toString
puts "--------------------ACTIONSCRIPT FUCK YEAH--------------"

