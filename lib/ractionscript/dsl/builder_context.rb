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
        #@_factory.newExpression( "(#{left.toString}) #{operator} (#{right.toString})")
        # NOTE the above works (as an alternative implementation of 'binary_expression') but it clutters everything with parenthesis
        # without the parenthesis it will discard order of operations from your ruby expression (unacceptable)
        case operator
          when :+
            @_factory.newAddExpression(left, right)
          when :-
            @_factory.newSubtractExpression(left, right)
          when :*
            @_factory.newMultiplyExpression(left, right)
          when :/
            @_factory.newDivisionExpression(left, right)
          when :and
            @_factory.newAndExpression(left, right)
          when :or
            @_factory.newOrExpression(left, right)
        end
      end

      def identifier_reference(identifier)
        @_factory.newExpression(identifier.to_s)
      end
    
      def literal(v)
        case v
          when Integer
            @_factory.newIntegerLiteral(v.to_i)
          else
            @_factory.newExpression(v.to_s)

        end
      end

      # accepts modifiers in any order
      # the first string is assumed to be the name
      # the string after that is the type
      def new_field(*name_type_and_modifiers)
        modifiers = []
        name, type = nil, nil
        name_type_and_modifiers.each do |v|
          case v
            when Symbol
              modifiers << v
            when String
              if name
                type = v
              else
                name = v
              end
          end
        end
        f = @_class.newField(name.to_s, Visibility.PUBLIC, type.to_s)
        # TODO find a way to use this generically for anything for which the modifier makes sense
        modifiers.each do |m|
          case m
            when :static;    f.setStatic(true)
            when :const;     f.setConst(true)
            when :public;    f.setVisibility(Visibility.PUBLIC)
            when :private;   f.setVisibility(Visibility.PRIVATE)
            when :protected; f.setVisibility(Visibility.PROTECTED)
            else
              raise "Unknown modifier #{m}"
          end
        end
        f
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
