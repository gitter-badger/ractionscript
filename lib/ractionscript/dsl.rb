require 'ractionscript/dsl/translators/class_definition'
require 'ractionscript/dsl/translators/method_definition'
require 'ractionscript/dsl/translators/expression'
require 'ractionscript/dsl/generators/compilation_unit'
require 'ractionscript/dsl/generators/method_definition'
require 'ractionscript/dsl/generators/expression'

module Ractionscript

  module DSL
    def DSL.process(ractionscript_source)

      sexp = Ractionscript::Sexp.ruby_string_to_sexp( ractionscript_source )
      
      # for development, display it in graphviz and highlight a matching subexpression
      #system "killall rsvg-view"  # temp, convenient for me
      
      highlight = Q?{
        s(:call, nil, :args!, _ % :paramlist) % :highlight
      }
      
      # translate the ruby-syntax s-expression
      # rewriting the parts that are meant to become actionscript
      # leaving the rest untouched
      # start from the highest level scope of ractionscript syntax (class definition)
      # motivation for splitting translators into many classes is:
      # 1) separation of concerns, potentially help make this a part of a generic library ruby-babel
      # 2) SexpBuilder is not recursive, i.e. it wont rewrite s-expressions within rewritten ones
      # so it is a chain of SexpBuilders (translators)
      
      # to visualize it anywhere along the way insert this between calls to translators or generators 'process'
      #Ractionscript::Sexp.viz_sexp(sexp, highlight); exit(0)
      
      sexp = Translators::ClassDefinition.new.process(sexp)
      
      sexp = Translators::MethodDefinition.new.process(sexp)
      
      sexp = Translators::Expression.new.process(sexp)
      
      # now generators...
      # at this point 'sexp' is not a valid ruby AST, it has a bunch of ractionscript specific things
      # the generators convert this to a ruby AST
      # which will build ActionScript AST with metaas Java classes
      
      sexp = Generators::CompilationUnit.new.process(sexp)
      
      sexp = Generators::MethodDefinition.new.process(sexp)
      
      sexp = Generators::Expression.new.process(sexp)
      
      # back to ruby source string
      sourcebuilder = Ruby2Ruby.new.process( sexp )
      
      #puts "--------------------source builder--------------"
      #puts sourcebuilder
      #puts "--------------------source builder--------------"
      
      # careful with class_eval, it'd better not litter or we better reload the class every time
      #load 'ractionscript/builder_context'
      
      BuilderContext.class_eval(sourcebuilder)
      
      # and now...
      
      context = BuilderContext.new
      
      compilation_unit = context.metacompile
      
      # 'metacompile' has returned an Rjb instance of the metaas compilation-unit class
      # we need a Java StringWriter instance to make 'compilation_unit' do it's thing
      
      string_writer = Ractionscript::JavaTypes::Util::StringWriter.new
      writer = Ractionscript::AST::Factory.newWriter
      writer._invoke('write',
                     'Ljava.io.Writer;Luk.co.badgersinfoil.metaas.dom.ASCompilationUnit;',
                     string_writer,
                     compilation_unit
                    )
      
      return string_writer.toString

    end
  end

end

