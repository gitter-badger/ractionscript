module Ractionscript

  module DSL

    module Generators

      class MethodDefinition < SexpBuilder
        include SexpTemplate

        # method definition (with or without a code block)
        # TODO support all modifiers and annotations
        template :method_definition do
          _ras_method = _ras_class.newMethod(name!, Visibility.PUBLIC, :void)
          method_definition_body!
        end

        # parameter in a method definition
        template :param do
          _ras_method.addParam(name!, type!)
        end

        # "rest" parameter in a method definition, e.g. parameter 'b' in function foo(a:int, ...b)
        template :rest_param do
          _ras_method.addRestParam(name!)
        end

        ## Initialize
        
        def initialize; super; end

          #########
          # Rules #
          #########

            rule :method_definition do
              s(:ras,
                :method_definition,
                _ % :method_name,
                _ % :method_definition_body
               )
            end

  
          #############
          # Rewriters #
          #############

            rewrite :method_definition do |m|
              render(:method_definition,
                     :name                   => m[:method_name],
                     :method_definition_body => m[:method_definition_body]
                    )
            end
          

      end

    end

  end

end

