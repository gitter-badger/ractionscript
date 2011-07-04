require 'ractionscript/dsl/translators/class_definition'
require 'ractionscript/dsl/translators/method_definition'
require 'ractionscript/dsl/translators/expression'
require 'ractionscript/dsl/generators/compilation_unit'
require 'ractionscript/dsl/generators/method_definition'
require 'ractionscript/dsl/generators/expression'
require 'ractionscript/dsl/visualize_sexp'

module Ractionscript

  module DSL

    # given a string of ractionscript source code
    # return a string of actionscript source code
    def DSL.process(ractionscript_source, builder_context)
      context_clazz = builder_context.class

      # get the ruby AST s-expression
      sexp = Ractionscript::Sexp.ruby_string_to_sexp( ractionscript_source )
      
      # translate the ruby AST s-expression
      # rewriting the parts that are meant to become actionscript
      # leaving the rest untouched
      # start from the highest level scope of ractionscript syntax (class definition)
      # motivation for splitting translators into many classes is:
      # 1) separation of concerns, potentially help make this a part of a generic library ruby-babel
      # 2) SexpBuilder is not recursive, i.e. it wont rewrite s-expressions within rewritten ones
      # so it is a chain of sexp processors
      
      sexp_processors = [
          # translators...
          # we are starting from a ruby AST s-expression
          # translators find the bits that are ractionscript's DSL syntax
        VisualizeSexp.new,
        Translators::ClassDefinition.new   , 
        VisualizeSexp.new,
        Translators::MethodDefinition.new  , 
        Translators::Expression.new(builder_context)        , 
          # now generators...
          # at this point 'sexp' is not a valid ruby AST, it has a bunch of ractionscript specific things
          # the generators convert this to a ruby AST
          # which will build ActionScript AST with metaas Java classes
        Generators::Expression.new         , 
        Generators::CompilationUnit.new    , 
        Generators::MethodDefinition.new   , 
          # insert these anywhere in the chain to visualize s-expressions (for development)
        #VisualizeSexp.new,
      ]

      system "killall rsvg-view"  # temp, convenient for me
      sexp = sexp_processors.inject(sexp) { |sexp, processor| processor.process(sexp) }

      # back to ruby source string
      sourcebuilder = Ruby2Ruby.new.process( sexp )
      
      # this may be useful for debugging
      puts "--------------------source builder--------------"
      puts sourcebuilder
      puts "--------------------source builder--------------"
      
      context_clazz.class_eval(sourcebuilder)
      
      # calling the generated code
      compilation_unit = builder_context.metacompile
      
      # 'metacompile' has returned an Rjb instance of the metaas compilation-unit class
      # we need a Java StringWriter instance to make 'compilation_unit' do it's thing
      
      string_writer = Ractionscript::JavaTypes::Util::StringWriter.new
      writer = Ractionscript::AST::Factory.newWriter
      writer._invoke('write',
                     'Ljava.io.Writer;Luk.co.badgersinfoil.metaas.dom.ASCompilationUnit;',
                     string_writer,
                     compilation_unit
                    )
      
      # return actionscript source code
      return string_writer.toString

    end
  end

end

