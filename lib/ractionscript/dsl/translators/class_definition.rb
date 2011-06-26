module Ractionscript

  module DSL
    
    module Translators

      class ClassDefinition < SexpBuilder

        def initialize; super; end

        #########
        # Rules #
        #########

          rule :class_definition_base do
            s(:call, nil, :class!, s(:arglist, _ % :class_name))
          end

          rule :class_definition do
            s(:iter, class_definition_base, nil, _ % :class_definition_body)
          end

  
        #############
        # Rewriters #
        #############

          rewrite :class_definition do |m|
            o = s(:ras, :class_definition, m[:class_name], m[:class_definition_body])
          end
        
      end

    end

  end

end

