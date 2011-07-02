module Ractionscript

  module DSL

    module Generators

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

  
          #############
          # Rewriters #
          #############

            rewrite :compilation_unit do |m|
              render(:compilation_unit,
                     :package_name          => s(:lit, "bar.baz.notimplemented"),  #FIXME
                     :name                  => m[:class_name],
                     :class_definition_body => m[:class_definition_body]
                    )
            end
          

      end

    end

  end

end

