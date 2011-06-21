require 'rjb'
require 'ruby2ruby'
require 'sexp_template'
require 'sexp_builder'
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

end

#require 'ractionscript/dsl/processor'
require 'ractionscript/dsl/generator'

# working method definition s-expression:
method_definition = s(:ras,
         :method_definition,
         "myMethod",
         "void",
         s(:block,
           s(:ras, :param, s(:str, "foo"), s(:str, "int")),
           s(:ras, :param, s(:str, "bar"), s(:str, "String")),
           s(:ras, :param, s(:str, "baz"), s(:nil)),  # example of an untyped parameter
           s(:ras, :rest_param, s(:str, "everythingelse"))
          )
        )

sexp = s(:ras,
         :compilation_unit,
         'Foo',
         'com.whatsys.actionscriptproject',
         s(:block,
           method_definition
          )
        )


#ap sexp

generator = Ractionscript::DSL::Generator.new
sourcebuilder = Ruby2Ruby.new.process( generator.process(sexp) )
#puts "and here's what it would actually do if you were foolish enough to run it"
#puts 
#puts sourcebuilder

class BuilderContext
  include Ractionscript::JavaTypes::MetaAs
end

BuilderContext.class_eval(sourcebuilder)
bc = BuilderContext.new
unit = bc.metacompile

sw = Ractionscript::JavaTypes::Util::StringWriter.new
Ractionscript::AST::Factory.newWriter.write(sw, unit)

#puts
#puts "and, whomp! here comes valid as3 source file I hope:"
#puts
puts sw.toString


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
