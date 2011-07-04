module Ractionscript

  module DSL
    
    module Translators

      module Expressions

        class Operator < SexpBuilder

          # some of ruby's binary operators, e.g. <=> and **, have no natural analogue in ActionScript
          # so for now they are not matched but maybe we could do something cool w them
          # TODO ruby's bitwise operators?
          # NOTE that these are not binary operators in ruby, in the strictest sense (that is the ruby parser treats them differently, notice they cannot be overridden),  && || ! and or not
          RUBY_BINARY_OPERATORS = %w( + - * / % == < <= > >= << >> )
          RUBY_BINARY_OPERATORS_REGEXP = Regexp.new(
            RUBY_BINARY_OPERATORS.collect{ |op| "^#{Regexp.escape(op)}$" }.join("|")
          )

          def initialize
            super
          end

          #########
          # Rules #
          #########

          rule :binary_expression do
            s(:call,
              _ % :operand_left,
              m(RUBY_BINARY_OPERATORS_REGEXP) % :operator,
              s(:arglist, _ % :operand_right)
             )
          end

          rule :boolean_binary_expression do
            any(
              s(m("and") % :operator, _ % :operand_left, _ % :operand_right),
              s(m("or")  % :operator, _ % :operand_left, _ % :operand_right)
            )
          end

          #############
          # Rewriters #
          #############

          rewrite :binary_expression, :boolean_binary_expression do |m|
            s(:ras,
              :binary_expression,
              process(m[:operand_left]),
              m[:operator],
              process(m[:operand_right])
             )
          end

        end

      end

    end

  end

end

