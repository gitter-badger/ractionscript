module Ractionscript

  module DSL

    module Generators

      class MethodDefinition < SexpBuilder
        include SexpTemplate

        def initialize; super; end

        # method definition (with or without a code block)
        # TODO support all modifiers and annotations
        template :method_definition do
          _ras_method = _ras_class.newMethod(name!, Visibility.PUBLIC, 'void')
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

        template :return_type do
          _ras_method.setType(return_type!.to_s)
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
                     :method_definition_body => m[:method_definition_body]
                    )
            end
          
            rewrite :paramlist do |m|
              o = s(:block)
              i = m[:paramlist]
              i.shift # :ras
              i.shift # :paramlist
              i.each_slice(2) do |name_and_type|
                name, type = name_and_type
                o.push s(:call,                     # this is like
                         s(:call,                   # _ras_method.addParam(name!.to_s, type!.to_s)
                           nil,
                           :_ras_method,
                           s(:arglist)),
                           :addParam,
                           s(:arglist,
                             s(:call, name, :to_s, s(:arglist)),
                             s(:call, type, :to_s, s(:arglist))
                            )
                        )
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

