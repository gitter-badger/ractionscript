module Ractionscript

  module DSL
    
    module Translators

      class Expression < SexpBuilder

        def initialize; super; end

        #########
        # Rules #
        #########

          rule :expression_base do
            # call to function exp! with no args
            s(:call, nil, :exp!, s(:arglist))
          end
          
          rule :expression do
            s(:iter, expression_base, nil, _ % :expression)
          end

          rule :string_expression do
            # call to function exp! with one string-like arg
            s(:call, nil, :exp!, s(:arglist, _ % :string_expression))
          end

          rule :comment do
            s(:call, nil, :comment!, s(:arglist, _ % :comment))
          end

        #############
        # Rewriters #
        #############

          rewrite :expression do |m|
            s(:ras,
              :expression,
              m[:expression])
          end

          rewrite :string_expression do |m|
            s(:ras,
              :string_expression,
              m[:string_expression])
          end

          rewrite :comment do |m|
            s(:ras,
              :comment,
              m[:comment])
          end
      end

    end

  end

end

