module Ractionscript

  module DSL
    
    module Translators

      module Expressions

        class Literal < SexpBuilder

          def initialize
            super
          end

          #########
          # Rules #
          #########

          # match string literals differently, they will need to be wrapped in quotes (FIXME and maybe should be escaped, check metaas docs?)
            rule :literal do
              s(:lit, atom % :literal)
            end

            rule :literal_string do
              s(:str, atom % :string_literal)
            end

          #############
          # Rewriters #
          #############

            rewrite :literal, :literal_string do |m|
              if m[:literal]
                s(:ras, :literal, s(:lit, m[:literal]))
              elsif m[:string_literal]
                s(:ras, :literal, s(:str, "\"#{m[:string_literal]}\""))
              end
            end

        end

      end

    end

  end

end


