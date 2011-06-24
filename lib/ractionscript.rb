require 'rjb'
require 'ruby2ruby'
require 'sexp_template'
require 'sexp_builder'
require File.join( File.dirname(__FILE__), 'ractionscript/dotvisuals' )
require 'awesome_print'

# add current dir to ruby load path
$:.unshift File.dirname(__FILE__)

#TODO platform agnostic defaults, and overrides by configuration
cp = %w(
/usr/share/java/antlr.jar
/usr/share/java/antlr3-3.0.1+dfsg.jar
/home/blake/src/metaas-svn/target/metaas-0.9-SNAPSHOT.jar
/usr/share/java/commons-io.jar
)

ENV["JAVA_HOME"] ||= "/usr/lib/jvm/java-6-openjdk"

Rjb::load(cp.join(":"))

module Ractionscript

  module JavaTypes

    module MetaAs
      Factory         = Rjb::import 'uk.co.badgersinfoil.metaas.ActionScriptFactory'
      CompilationUnit = Rjb::import 'uk.co.badgersinfoil.metaas.dom.ASCompilationUnit'
      ClassType       = Rjb::import 'uk.co.badgersinfoil.metaas.dom.ASClassType'
      Visibility      = Rjb::import 'uk.co.badgersinfoil.metaas.dom.Visibility'
      #= Rjb::import ''
    end

    module Util
      StringReader = Rjb::import 'java.io.StringReader'
      StringWriter = Rjb::import 'java.io.StringWriter'
    end

  end

  module AST
    # singleton factory
    Factory = Ractionscript::JavaTypes::MetaAs::Factory.new
  end

  module Sexp
    def self.ruby_string_to_sexp(ruby)
      sexp = RubyParser.new.parse(ruby)
      Unifier.new.process(sexp)
    end

    def self.viz_sexp(sexp, sexp_path_query=nil)
      File.open("./output.tmp", "w") { |f| f.write sexp.to_dot(sexp_path_query) }
      `dot -Tsvg output.tmp > output.tmp.svg`
      `xsltproc /home/blake/w/diagram-tools/notugly.xsl output.tmp.svg > output.notugly.svg`
      #`rm -f output.tmp output.tmp.svg`
      `rm -f output.tmp.svg`
      system "rsvg-view output.notugly.svg &"
    end
  end

end

#require 'ractionscript/dsl/processor'
require 'ractionscript/dsl/translator'
require 'ruby_parser'

ractionscript_source_file = File.join( File.dirname( __FILE__ ) , 'ractionscript_simpletest.as3.rb' )
ractionscript_source = File.read( ractionscript_source_file )

highlight = Q?{
        s(:call,
          nil,
          :args,
          s(:arglist, _ % :arglist))\
% :k
}

sexp = Ractionscript::Sexp.ruby_string_to_sexp ractionscript_source 
match = (sexp / highlight).first

Ractionscript::Sexp.viz_sexp( sexp, match[:k] )

translator = Ractionscript::DSL::Translator.new
newsexp = translator.process(sexp, highlight)

#Ractionscript::Sexp.viz_sexp( newsexp  )
#sourcebuilder = Ruby2Ruby.new.process( translator.process(sexp) )
#puts "and here's what it would actually do if you were foolish enough to run it"
#puts 
#puts sourcebuilder

#class BuilderContext
#  include Ractionscript::JavaTypes::MetaAs
#end
#
#BuilderContext.class_eval(sourcebuilder)
#bc = BuilderContext.new
#unit = bc.metacompile
#
#sw = Ractionscript::JavaTypes::Util::StringWriter.new
#Ractionscript::AST::Factory.newWriter.write(sw, unit)
#
##puts
##puts "and, whomp! here comes valid as3 source file I hope:"
##puts
#puts sw.toString


