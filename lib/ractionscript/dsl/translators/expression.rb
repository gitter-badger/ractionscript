module Ractionscript

  module DSL
    
    module Translators

      class Expression < SexpBuilder

        def initialize; super; end

        #########
        # Rules #
        #########

        # e.g.
        # exp!
          rule :expression_base do
            s(:call, nil, :exp!, s(:arglist))
          end
          
        # e.g.
        # exp! { a + b.foo(c) }
          rule :expression do
            s(:iter, expression_base, nil, _ % :expression)
          end

        # e.g.
        # exp! "1 + 2"
          rule :string_expression do
            # call to function exp! with one string-like arg
            s(:call, nil, :exp!, s(:arglist, _ % :string_expression))
          end

        # e.g.
        # comment! "foo bar baz"
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

