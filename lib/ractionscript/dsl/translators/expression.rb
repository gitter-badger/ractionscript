require 'ractionscript/dsl/translators/expressions/operator.rb'
require 'ractionscript/dsl/translators/expressions/identifier.rb'
require 'ractionscript/dsl/translators/expressions/literal.rb'

module Ractionscript

  module DSL
    
    module Translators

      class Expression < SexpBuilder

        def initialize(builder_context)
          super()
          @translators = [
            Ractionscript::DSL::Translators::Expressions::Operator.new,
            Ractionscript::DSL::Translators::Expressions::Identifier.new(builder_context),
            Ractionscript::DSL::Translators::Expressions::Literal.new,
            # insert these anywhere in the chain to visualize s-expressions (for development)
            #VisualizeSexp.new( Q?{} ) ,
          ]
        end

        # un-rubifies the expression
        # that is, makes it a generic ractionscript representation
        # there should be nothing very ruby-specific left
        # with the exception of references to local variables
        # or method calls to methods which are defined
        # (calls to missing methods are how you specify ActionScript identifiers)
        def translate_expression(expression)
          @translators.inject(expression) { |e, p| p.process(e) }
        end

        #########
        # Rules #
        #########

        # e.g.
        # exp!
          rule :expression_base do
            s(:call, nil, :exp!, s(:arglist))
          end
          
        # e.g.
        # exp! { a + b.foo(c) }
          rule :expression do
            s(:iter, expression_base, nil, _ % :expression)
          end

        # e.g.
        # exp! "1 + 2"
          rule :string_expression do
            # call to function exp! with one string-like arg
            s(:call, nil, :exp!, s(:arglist, _ % :string_expression))
          end

        # e.g.
        # comment! "foo bar baz"
          rule :comment do
            s(:call, nil, :comment!, s(:arglist, _ % :comment))
          end

        #############
        # Rewriters #
        #############

          rewrite :expression do |m|
            s(:ras, :expression,
              translate_expression(m[:expression])
             )
          end

          rewrite :string_expression do |m|
            s(:ras,
              :string_expression,
              m[:string_expression])
          end

          rewrite :comment do |m|
            s(:ras,
              :comment,
              m[:comment])
          end
      end

    end

  end

end

