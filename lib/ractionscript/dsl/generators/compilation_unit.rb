module Ractionscript

  module DSL

    module Generators

      class CompilationUnit < SexpBuilder
        include SexpTemplate

        # top level class (compilation unit)
        #TODO support modifiers and annotations
        template :compilation_unit do
          _ras_factory = Ractionscript::AST::Factory
          _ras_comp_unit = _ras_factory.newClass(name!)
          _ras_comp_unit.setPackageName(package_name!)
          _ras_class = _ras_comp_unit.getType
          class_definition_body!
          _ras_comp_unit
        end

        ## Initialize
        
        def initialize; super; end

          #########
          # Rules #
          #########

            rule :compilation_unit do
              s(:ras,
                :compilation_unit,
                _ % :class_name,
                _ % :class_definition_body
               )
            end

  
          #############
          # Rewriters #
          #############

            rewrite :compilation_unit do |m|
              render(:compilation_unit,
                     :package_name          => "bar.baz.notimplemented",  #FIXME
                     :name                  => m[:class_name],
                     :class_definition_body => m[:class_definition_body]
                    )
            end
          

      end

    end

  end

end

