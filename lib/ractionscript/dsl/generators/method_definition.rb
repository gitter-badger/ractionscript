module Ractionscript

  module DSL

    module Generators

      class MethodDefinition < SexpBuilder
        include SexpTemplate

        def initialize; super; end

          #############
          # Templates #
          #############

            # method definition (with or without a code block)
            # TODO support all modifiers and annotations
            template :method_definition do
              new_method name!
              method_definition_body!
            end

            # parameter in a method definition
            template :param do
              add_param name!, type!
            end

            #TODO implement this
            # "rest" parameter in a method definition, e.g. parameter 'b' in function foo(a:int, ...b)
            #template :rest_param do
            #  _ras_method.addRestParam(name!)
            #end

            template :return_type do
              set_return_type return_type!
            end

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

            # NOTE this might be not restrictive enough, it might match expressions which _contain_ paramlists but aren't paramlists themselves EXAMINE
            rule :paramlist do
              all(
                t(:ras),
                include(:paramlist)
              ) % :paramlist
            end
  
            rule :return_type do
              s(:ras, :return_type, _ % :return_type)
            end
  
          #############
          # Rewriters #
          #############

            rewrite :method_definition do |m|
              render(:method_definition,
                     :name                   => m[:method_name],
                     :method_definition_body => self.process(m[:method_definition_body])  # NOTE recursive on body
                    )
            end
          
            rewrite :paramlist do |m|
              o = s(:block)
              i = m[:paramlist]
              i.shift # :ras
              i.shift # :paramlist
              i.each_slice(2) do |name_and_type|
                name, type = name_and_type
                o.push render(:param, :name => name, :type => type)
              end
              o
            end

            rewrite :return_type do |m|
              render(:return_type, :return_type => m[:return_type])
            end

      end

    end

  end

end

