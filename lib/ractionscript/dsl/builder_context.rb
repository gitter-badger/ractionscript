module Ractionscript

  module DSL

    class BuilderContext

      include Ractionscript::JavaTypes::MetaAs
    
      def initialize
        @_factory    = Ractionscript::AST::Factory
        @_method     = nil
        @_code_block = nil
        @_class      = nil
      end
    
      def new_class(name)
        @_comp_unit = @_factory.newClass(name)
        @_comp_unit.setPackageName("fixme.packages.are.not.implemented") #FIXME
        @_class = @_comp_unit.getType
      end
    
      def new_method(name)
        @_code_block =
        @_method =
          @_class.newMethod(name, Visibility.PUBLIC, 'void')
      end

      def binary_expression(operator, left, right)
        #FIXME fill in the rest of this glue
        case operator
          when :*
            @_factory.newMultiplyExpression(left, right)
          when :+
            @_factory.newAddExpression(left, right)
        end
      end

      def identifier_reference(identifier)
        @_factory.newExpression(identifier.to_s)
      end
    
      def lit_int(v)
        @_factory.newIntegerLiteral(v.to_i)
      end
    
      def add_param(name, type); @_method.addParam(name.to_s, type.to_s); end
    
      #TODO maybe.. make this warn if you are setting it a second time?
      def set_return_type(type); @_method.setType(type.to_s); end
    
      def add_string_expression(s); @_code_block.addStmt(s); end
    
      def add_expression(s); @_code_block.newExprStmt(s); end
    
      def add_comment(s); @_code_block.addComment(s); end
    
    end

  end

end
