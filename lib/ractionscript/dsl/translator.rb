module Ractionscript

  module DSL

    class Translator < SexpBuilder
      #include SexpTemplate

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
      # accept any old ruby expression and trust the programmer that it evaluates as a string
      rule :method_definition_name do
        s( _ % :method_name )
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
      
    end

  end

end



