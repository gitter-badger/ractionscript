# add current dir to ruby load path
$:.unshift File.dirname(__FILE__)

# dependencies
require 'rjb'
require 'ruby2ruby'
require 'sexp_template'
require 'sexp_builder'
require 'ruby_parser'

# internals
require 'ractionscript/dsl/generator'
require 'ractionscript/dsl/translators/class_definition'
require 'ractionscript/dsl/translators/method_definition'
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
            s(:iter, s(:call, nil, :class!, s(:arglist, _ % :class_name)), nil, _ % :class_definition_body)
}
Ractionscript::Sexp.viz_sexp sexp, highlight, :class_definition_body

# translate the ruby-syntax s-expression
# rewriting the parts that are meant to become actionscript
# leaving the rest untouched
# start from the highest level scope of ractionscript syntax (class definition)
# work down the scope rules
# reason is that SexpBuilder wont rewrite s-expressions within rewritten ones
# so it has to be a chain
sexp = Ractionscript::DSL::Translators::ClassDefinition.new.process(sexp)
sexp = Ractionscript::DSL::Translators::MethodDefinition.new.process(sexp)
Ractionscript::Sexp.viz_sexp sexp, highlight

