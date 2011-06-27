module Ractionscript

  module DSL
    
    module Translators

      class MethodDefinition < SexpBuilder

        def initialize; super; end

        #########
        # Rules #
        #########

          # specify arguments
          rule :method_definition_paramlist do
            s(:call, nil, :args!,
              _ % :paramlist)    # any number of params
          end
  
          # specify a return type
          rule :method_definition_return_type do
            s(:call, nil, :return_type!,
              s(:arglist, _ % :return_type))    # exactly one arg
          end
  
          # a necessary subexpression of method_definition
          # amounts to the part might look like:
          # function!("myMethod")
          # accept any old ruby expression as the name and trust the programmer that it evaluates as a string
          rule :method_definition_base do
            s(:call,
              nil,
              :function!,
              s(:arglist, _ % :method_name ) )
          end
  
          # define a method
          # matches with body there or not
          rule :method_definition do
            any(
              method_definition_base,
              s(:iter, method_definition_base, nil, _ % :method_definition_body)
            )
          end
  
        #############
        # Rewriters #
        #############

          #TODO rewrite expressions in function bodies

          rewrite :method_definition_paramlist do |m|
            i = m[:paramlist]         # input
            o = s(:ras, :paramlist)   # output
            i.shift                 # throw away :arglist
            i = i.shift             # get hash
            i.shift                 # throw away :hash
            i.each { |n| o.push n } # copy arg expressions
            o
          end
          
          rewrite :method_definition_return_type do |m|
            s(:ras, :return_type, m[:return_type])
          end

          rewrite :method_definition do |m|
            body = m[:method_definition_body] || s(:lit, :nil)
            s(:ras, :method_definition, m[:method_name], body)
          end
          
      end

    end

  end

end


