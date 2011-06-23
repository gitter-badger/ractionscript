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

  #module DSL
  #  autoload :Processor, 'ractionscript/dsl/processor'
  #  autoload :Generator, 'ractionscript/dsl/generator'
  #end

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
    def self.proc_to_sexp(blk)
      pt = ParseTree.new(false)
      sexp = pt.parse_tree_for_proc(blk)
      Unifier.new.process(sexp)
    end
  end

end

#require 'ractionscript/dsl/processor'
require 'ractionscript/dsl/generator'
require 'ruby_parser'


n = 42
my_ractionscript_code = proc {

# this is how ractionscript source might look
  args :x   => :int,
       :y   => :int,
       :z   => nil,
       :all => :rest
  returN :int
  function("mySoonToBeActionScriptFunction#{n}") { 
    #this should become actionscript
    exp! { x = (y + 3) * 2 }
    #this should still be ruby
    x = (y + 3) * 2
  }

}

sexp = Ractionscript::Sexp.proc_to_sexp my_ractionscript_code 

# or load ractionscript source from file:
#code = File.read(ARGV[0])
#sexp = RubyParser.new.parse(code)

generator = Ractionscript::DSL::Generator.new
newsexp = generator.process(sexp)
File.open("./output", "w") { |f| f.write newsexp.to_dot }
`head -2 output > output.header`
`tail -1 output > output.footer`
`cat output | sort | uniq | grep -v digraph | grep -v node | grep -v \\} > output.unfucked`
`cat output.header output.unfucked output.footer > output`
`dot -Tsvg output > output.svg`
#`xsltproc /home/blake/w/diagram-tools/notugly.xsl output.svg > output.notugly.svg`
#`rm -f output.header output.footer output`
puts "rsvg-view output.svg"
system "rsvg-view output.svg"
#ap generator.process(sexp)
#generator.process(sexp)
#sourcebuilder = Ruby2Ruby.new.process( generator.process(sexp) )
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


#Ras = Ractionscript
#
## parse actionscript source:
#
#sourcefile = "/home/blake/w/ruby2as/util/AdController.as"
#
#source = File.read(sourcefile)
#
#f = Ras::AST::Factory
#sr = Ras::JavaTypes::Util::StringReader
#
#compunit = f.newParser.parse( sr.new(source) )
#
#clazz = compunit.getType
#
#puts "#{sourcefile} defines #{compunit.getPackageName}.#{clazz.getName}"
#
## rename the class:
#clazz.setName "DumbClass"
#
#sw = Ras::JavaTypes::Util::StringWriter.new
#f.newWriter.write(sw, compunit)
#puts sw.toString
