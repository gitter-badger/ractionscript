module Ractionscript

  module DSL
    
    module Generators

      module Expressions

        class Literal < SexpBuilder
          include SexpTemplate

          def initialize
            super
          end

          #############
          # Templates #
          #############

            template :lit_int do 
              lit_int v!
            end

          #########
          # Rules #
          #########

            rule :lit_int do
              s(:ras, :lit_int, atom % :v)
            end

          #############
          # Rewriters #
          #############
            
            rewrite :lit_int do |m|
              render(:lit_int, :v => s(:lit, m[:v]))
            end

        end

      end

    end

  end

end
