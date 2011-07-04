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

            template :literal do 
              literal v!
            end

          #########
          # Rules #
          #########

            rule :literal do
              s(:ras, :literal, atom % :v)
            end

          #############
          # Rewriters #
          #############
            
            rewrite :literal do |m|
              render(:literal, :v => s(:lit, m[:v]))
            end

        end

      end

    end

  end

end
