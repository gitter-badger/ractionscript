module Ractionscript

  module DSL
    
    module Generators

      module Expressions

        class Operator < SexpBuilder
          include SexpTemplate

          def initialize
            super
          end

          #############
          # Templates #
          #############

            template :binary_expression do
              binary_expression operator!, operand_left!, operand_right!
            end

          #########
          # Rules #
          #########

            rule :binary_expression do
              s(:ras,
                :binary_expression,
                _ % :operand_left,
                atom % :operator,
                _ % :operand_right
               )
            end

          #############
          # Rewriters #
          #############
            
            rewrite :binary_expression do |m|
              render(:binary_expression,
                     :operator      => s(:lit, m[:operator]),
                     :operand_left  => process(m[:operand_left]),
                     :operand_right => process(m[:operand_right])
                    )
            end

        end

      end

    end

  end

end
