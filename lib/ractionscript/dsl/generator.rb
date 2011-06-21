module Ractionscript

  module DSL

    class Generator < SexpProcessor
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
        self.auto_shift_type = true
      end
      
      ## Processors (rewriters of s-expressions)
      def process_ras(exp)
        type = exp.shift
        send("ras_#{type}", exp)
      end

      def ras_compilation_unit(exp)
        render :compilation_unit,
               :name         => s(:str, exp.shift),
               :package_name => s(:str, exp.shift),
               :content      => process(exp.shift)
      end

      def ras_method_definition(exp)
        render :method_definition,
               :name        => s(:str, exp.shift),
               :return_type => s(:str, exp.shift),
               :content     => process(exp.shift)
      end

      def ras_param(exp)
        render :param, :name => exp.shift, :type => exp.shift
      end

      def ras_rest_param(exp)
        render :rest_param, :name => exp.shift
      end

    end

  end

end

# straight from the horse's mouth (metaas docs)

#  ASArg                           A parameter in a method or function definition.
#  ASArrayAccessExpression         An array access, such as a[1].
#  ASArrayLiteral                  An array literal expression, such as [1, 2, 3].
#  ASAssignmentExpression          An assignment expression, such as a = b or a += b.
#  ASBinaryExpression              A binary expression, such as a + b or a && b.
#  ASBlock                         A code-block, as used for a while-loop body or if-statement branch.
#  ASBooleanLiteral                A boolean literal expression, such as true or false.
#  ASBreakStatement                A break statement.
#  ASCatchClause                   A catch clause within a try statement.
#  ASClassType                     A handle on the definition of an ActionScript class.
#  ASCompilationUnit               A 'compilation unit' represents an entire file of ActionScript code.
#  ASConditionalExpression         A 'conditional' (or 'ternary') expression, such as a ? b : c.
#  ASConstants                     Constant values giving the names of the fundamental ActionScript types
#  ASContinueStatement             A continue statement, as allowed within the various loop-statements.
#  ASDeclarationStatement          A statement that declares variables, such as var a = 1;.
#  ASDefaultXMLNamespaceStatement  A statement setting the default XML namespace for the current scope, such as default xml namespace = "http://example.com/";
#  ASDescendantExpression          An E4X descendant expression, such as a..b
#  ASDoWhileStatement              A do-while loop, such as do { } while (condition);.
#  ASExpressionAttribute           An attribute-access expression defined in terms of some other expression, such as @[baseName+n].
#  ASExpressionStatement           A simple statement which evaluates an expression.
#  ASField                         A field definition within an ActionScript class.
#  ASFieldAccessExpression         An expression that accesses a field of an object, such as person().name.
#  ASFilterExpression              An E4X filter-predicate expression, such as myElem.(@myAttr=='1').
#  ASFinallyClause                 A finally clause within a try statement.
#  ASForEachInStatement            A for-each-in statement, such as for each(v in a) { }.
#  ASForInStatement                A for-in statement, such as for (v in a) { }.
#  ASForStatement                  A for statement, such as for (; ; ) { }.
#  ASFunctionExpression            A function-expression, such as in a = function() { }.
#  ASIfStatement                   An if-statement, such as if (a) { doSomething(); }.
#  ASIntegerLiteral                An integer literal expression, such as 123.
#  ASInterfaceType                 A handle on the definition of an ActionScript interface.
#  ASInvocationExpression          An invocation of a method or function, such as a().
#  ASMember                        A member of a type; an ASMethod or ASField.
#  ASMetaTag                       A 'metadata tag' which may be attached to types, methods or fields.
#  ASMetaTag.Param                 A 'named parameter' within a metatag.
#  ASMethod                        An ActionScript method definition within an ActionScript class or interface.
#  ASNewExpression                 A constructor invocation, such as new MyThing().
#  ASNullLiteral                   A literal null value; the keyword null.
#  ASObjectLiteral                 An object-literal-expression, such as {a: "b", c: 2}.
#  ASObjectLiteral.Field           A field within an object literal
#  ASPackage                       A package-declaration block, such as package com.example { }.
#  ASPostfixExpression             A postfix-expression, such as a++ or a--.
#  ASPrefixExpression              A prefix-expression, such as !a or ++a.
#  ASPropertyAttribute             An attribute-access-expression, such as @myAttr.
#  ASRegexpLiteral                 A literal 'regular expression', such as /[a-z]+/
#  ASReturnStatement               A return statement, such as return; or return res;.
#  ASSimpleNameExpression          A simple name, such as foo.
#  ASStarAttribute                 The star-attribute-identifier, @*.
#  ASStringLiteral                 A literal string value, such as "foo" or 'bar'.
#  ASSuperStatement                A call to a superclass constructor, such as super(args);.
#  ASSwitchCase                    A switch-statement case-label, and the list of statements immediately following it.
#  ASSwitchDefault                 A switch-statement default: label, and the list of statements immediately following it.
#  ASSwitchStatement               A switch-statement, such as switch (c) { }.
#  ASThrowStatement                A throw-statement, such as throw new Error("bang!");.
#  ASTryStatement                  A try-statement, such as try { } catch (e) { }.
#  ASType                          Superinterface for ASClassType and ASInterfaceType.
#  ASUndefinedLiteral              A literal 'undefined' value; the undefined keyword;
#  ASVarDeclarationFragment        The declaration of a single variable in a variable-declaration-statement, such as the a:String in var a:String;
#  ASWhileStatement                A while-loop, such as while (test()) { }.
#  ASWithStatement                 A with-statement, such as with (expr) { }.
#  ASXMLLiteral                    An E4X literal XML fragment, such as in a = <hello>world</hello>;.
#  AttributeExpression             Supertype for expressions of the form @...
#  DocComment                      Allows manipulation of any 'documentation comment' attached to an ActionScript API element.
#  DocTag                          A 'block' tag within a DocComment.
#  Documentable                    Interface extended by ScriptElements which can have API documentation comments attached.
#  Expression                      The supertype for all interfaces which represent ActionScript 3 expressions.
#  FunctionCommon                  Common interface for ASMethod and ASFunctionExpression.
#  Invocation                      Common details for ASInvocationExpression and ASNewExpression.
#  Literal                         Supertype for all expressions which are 'literal' values, like strings and numbers.
#  MetaTagable                     The common interface for API elements that may be tagged with metadata.
#  ScriptElement                   The supertype for all elements in the metaas Document Object Model.
#  Statement                       Super-interface for tagging objects that represent ActionScript 'statements'.
#  StatementContainer              Defines the common services provided by structures which can contain ActionScript 'statements'.
#  SwitchLabel                     Common super-type for entries that may appear in ASSwitchStatement: ASSwitchCase and ASSwitchDefault.
#  Visibility                      Access allowed to a class member from other classes, as specified by the public, private, protected and internal modifiers (or lack of) in the member's definition.
