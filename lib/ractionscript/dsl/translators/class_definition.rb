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

        # e.g.
        # field!(:private, :static, :const, 'foo', 'int')
          rule :field_definition do
            s(:call, nil, :field!, _ % :arglist)
          end

        # e.g.
        # .init!(...)
          rule :initializer do
            s(:call, _ % :receiver, :init!, s(:arglist, _ % :init_exp ))
          end

  
        #############
        # Rewriters #
        #############

          rewrite :class_definition do |m|
            s(:ras,
              :class_definition,
              m[:class_name],
              process(m[:class_definition_body])
             )
          end

          rewrite :field_definition do |m|
            s(:ras,
              :class_field_definition,
              m[:arglist]
             )
          end

          rewrite :initializer do |m|
            s(:call,
              process(m[:receiver]),
              :setInitializer,
              Generators::Expression.generate_expression( Expression.translate_expression(m[:init_exp], nil) )
             )
          end

      end

    end

  end

end

