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

            rule :literal do
              s(:lit, atom % :v)
            end

          #############
          # Rewriters #
          #############

          #FIXME support other literals, map from ruby type to as type
            rewrite :literal do |m|
              s(:ras, :lit_int, m[:v])
            end

        end

      end

    end

  end

end


