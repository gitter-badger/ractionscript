require 'rjb'
require 'ruby2ruby'
require 'sexp_template'
require 'sexp_builder'

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

end

#require 'ractionscript/dsl/processor'
require 'ractionscript/dsl/generator'

sexp = s(:ras,
         :compilation_unit,
         s(:lit, 'foo')
        )
 puts sexp.inspect

#require 'ruby-debug';debugger
result = Ractionscript::DSL::Generator.new.process(sexp)
puts "after processing: " 
puts result.inspect
foo = Ruby2Ruby.new.process(result)
puts "and here's what it would actually do"
puts 
puts foo



#Ras = Ractionscript
#
## simple test:
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
#clazz.setName "ShittyBalls"
#
#sw = Ras::JavaTypes::Util::StringWriter.new
#f.newWriter.write(sw, compunit)
#puts sw.toString
