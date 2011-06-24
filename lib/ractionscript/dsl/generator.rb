module Ractionscript

  module DSL

    class Generator < SexpBuilder
      include SexpTemplate

      # top level class (compilation unit)
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

    end

  end

end
