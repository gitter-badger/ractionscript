module Ractionscript

  module DSL

    class Generator < SexpBuilder
      include SexpTemplate

      # top level class (source file, compilation unit)
      #TODO support modifiers and annotations
      template :compilation_unit do
        def metacompile
        _ras_factory = Ractionscript::AST::Factory
        _ras_comp_unit = _ras_factory.newClass(name!)
        _ras_comp_unit.setPackageName(package_name!)
        _ras_class = _ras_comp_unit.getType
        content!
        _ras_comp_unit
        end
      end

      # method definition (with or without a code block)
      # TODO support all modifiers and annotations
      template :method_definition do
        _ras_method = _ras_class.newMethod(name!, Visibility.PUBLIC, return_type!)
        content!
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
      
      def initialize
        super
      end

      # specify arguments
      rule :method_definition_arglist do
        s(:call,
          nil,
          :args,
          s(:arglist, _ % arglist))
      end

      # specify a return type
      rule :method_definition_return_type do
        s(:call,
          nil,
          :returN,
          s(:arglist, _ % :return_type))
      end

      # specify the name of a method
      rule :method_definition_name do
        any( t(:dstr) % :method_name, t(:str) % :method_name)
      end

      # a necessary subexpression of method_definition
      # amounts to the part might look like:
      # function("myMethod")
      rule :method_definition_base do
        s(:call,
          nil,
          :function,
          s(:arglist, method_definition_name % :method_name))
      end

      # define a method
      # matches with body there or not
      rule :method_definition do
        any(
          s(:iter, method_definition_base, nil),
          s(:iter, method_definition_base, nil,
            _ % :method_definition_body)
        )
      end

      #############
      # Rewriters #
      #############

#TODO rewrite argument list
#TODO rewrite AS expressions within the body
#TODO call templates from rewriters
      rewrite :method_definition_return_type do |m|
        s(:ras,
          :return_type,
          m[:return_type])
      end

      rewrite :method_definition do |m|
        s(:ras,
          :method_definition,
          m[:method_name],
          m[:method_definition_body]
        )
      end
      

#method_definition = s(:ras,
#         :method_definition,
#         "myMethod",
#         "void",
#         s(:block,
#           s(:ras, :param, s(:str, "foo"), s(:str, "int")),
#           s(:ras, :param, s(:str, "bar"), s(:str, "String")),
#           s(:ras, :param, s(:str, "baz"), s(:nil)),  # example of an untyped parameter
#           s(:ras, :rest_param, s(:str, "everythingelse"))
#          )
#        )

    end

  end

end



