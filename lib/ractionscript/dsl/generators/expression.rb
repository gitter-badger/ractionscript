module Ractionscript

  module DSL

    module Generators

      class Expression < SexpBuilder
        include SexpTemplate
        
        def initialize; super; end

          #############
          # Templates #
          #############

            template :string_expression do
              _ras_method.addStmt( string_expression! )
            end

            template :comment do
              _ras_method.addComment( comment! )
            end

          #########
          # Rules #
          #########

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

