module Ractionscript

  module DSL
    
    module Translators

      class ClassDefinition < SexpBuilder

        def initialize; super; end

        #########
        # Rules #
        #########

        # e.g.
        # class!("MyClass")
          rule :class_definition_base do
            s(:call, nil, :class!, s(:arglist, _ % :class_name))
          end

        # e.g.
        # class!("MyClass") { ... }
          rule :class_definition do
            s(:iter, class_definition_base, nil, _ % :class_definition_body)
          end

  
        #############
        # Rewriters #
        #############

          rewrite :class_definition do |m|
            s(:ras,
              :class_definition,
              m[:class_name],
              m[:class_definition_body]
             )
          end

      end

    end

  end

end

