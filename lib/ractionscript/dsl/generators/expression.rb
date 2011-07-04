require 'ractionscript/dsl/generators/expressions/operator.rb'
require 'ractionscript/dsl/generators/expressions/identifier.rb'
require 'ractionscript/dsl/generators/expressions/literal.rb'

module Ractionscript

  module DSL

    module Generators

      class Expression < SexpBuilder
        include SexpTemplate

        def self.generate_expression(expression)
          [
            Expressions::Operator.new,
            Expressions::Identifier.new,
            Expressions::Literal.new,
            #VisualizeSexp.new(  ),
          ].inject(expression) { |e,p| p.process(e) }
        end
        
        def initialize
          super
          @generators = [
            Expressions::Operator.new,
            Expressions::Identifier.new,
            Expressions::Literal.new,
            #VisualizeSexp.new(  ),
          ]
        end

        def generate_expression(expression)
          @generators.inject(expression) { |e, p| p.process(e) }
        end

          #############
          # Templates #
          #############

            template :expression do
              add_expression expression!
            end

            template :string_expression do
              add_string_expression string_expression!
            end

            template :comment do
              add_comment comment!
            end

          #########
          # Rules #
          #########

            rule :expression do
              s(:ras,
                :expression,
                _ % :expression
               )
            end

            rule :string_expression do
              s(:ras,
                :string_expression,
                _ % :string_expression
               )
            end

            rule :comment do
              s(:ras,
                :comment,
                _ % :comment)
            end

          #############
          # Rewriters #
          #############

            rewrite :expression do |m|
              render(:expression,
                     :expression => generate_expression(m[:expression])
                    )
            end

            rewrite :string_expression do |m|
              render(:string_expression,
                     :string_expression => m[:string_expression]
                    )
            end
          
            rewrite :comment do |m|
              render(:comment,
                     :comment => m[:comment]
                    )
            end
      end

    end

  end

end

