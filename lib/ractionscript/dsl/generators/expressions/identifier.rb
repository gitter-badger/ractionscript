module Ractionscript

  module DSL
    
    module Generators

      module Expressions

        class Identifier < SexpBuilder
          include SexpTemplate

          def initialize
            super
          end

          #############
          # Templates #
          #############

            template :identifier_reference do
              identifier_reference identifier_reference!
            end

          #########
          # Rules #
          #########

            rule :identifier do
              s(:ras, :identifier, atom % :identifier)
            end

          #############
          # Rewriters #
          #############

            rewrite :identifier do |m|
              render( :identifier_reference, :identifier_reference => s(:lit, m[:identifier]) )
            end
        end

      end

    end

  end

end
