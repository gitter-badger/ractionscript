module Ractionscript

  module DSL

    module Generators

      # FIXME rename this ClassDefinition
      class CompilationUnit < SexpBuilder
        include SexpTemplate

        # top level class (compilation unit)
        #TODO support modifiers and annotations
        template :compilation_unit do
          def metacompile
            new_class name!
            class_definition_body!
            @_comp_unit
          end
        end

        ## Initialize
        
        def initialize; super; end

          #########
          # Rules #
          #########

            rule :compilation_unit do
              s(:ras,
                :class_definition,
                _ % :class_name,
                _ % :class_definition_body
               )
            end

            rule :class_field_definition do
              s(:ras,
                :class_field_definition,
                _ % :arglist
               )
            end
  
          #############
          # Rewriters #
          #############

            rewrite :compilation_unit do |m|
              render(:compilation_unit,
                     :package_name          => s(:lit, "bar.baz.notimplemented"),  #FIXME
                     :name                  => m[:class_name],
                     :class_definition_body => process(m[:class_definition_body])
                    )
            end
          
            rewrite :class_field_definition do |m|
              s(:call, nil, :new_field, m[:arglist])
            end

      end

    end

  end

end

