module Ractionscript

  module DSL
    
    module Translators

      module Expressions

        class Identifier < SexpBuilder

          def initialize(builder_context)
            super()
            @builder_context = builder_context
          end

          #########
          # Rules #
          #########

          # a call on self with empty arglist _might_ be an ActionScript identifier
          # depending on whether the method is defined in @builder_context
            rule :possible_identifier do
              s(:call, nil, atom % :identifier, s(:arglist) ) % :possible_identifier
            end

          #############
          # Rewriters #
          #############

            rewrite :possible_identifier do |m|
              if @builder_context.respond_to?(m[:identifier])
                # method exists, leave it as a ruby expression to be passed through unchanged
                return m[:possible_identifier]
              else
                # method does not exist, mark it as a reference to an ActionScript identifier
                s(:ras, :identifier, m[:identifier])
              end
            end

        end

      end

    end

  end

end


