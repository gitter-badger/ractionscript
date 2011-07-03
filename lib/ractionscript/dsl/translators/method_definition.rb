module Ractionscript

  module DSL
    
    module Translators

      class MethodDefinition < SexpBuilder

        def initialize; super; end

        #########
        # Rules #
        #########

        # e.g.
        # args! :foo => :int, :bar => :String
          rule :method_definition_paramlist do
            s(:call, nil, :args!,
              _ % :paramlist)    # any number of params
          end
  
        # e.g.
        # return_type! :int
          rule :method_definition_return_type do
            s(:call, nil, :return_type!,
              s(:arglist, _ % :return_type))    # exactly one arg
          end
  
        # e.g.
        # function!("myMethod")
          rule :method_definition_base do
            s(:call,
              nil,
              :function!,
              s(:arglist, _ % :method_name ) )
          end
  
        # e.g.
        # function!("myMethod") { ... }
          rule :method_definition do
            any(
              method_definition_base,
              s(:iter, method_definition_base, nil, _ % :method_definition_body)
            )
          end
  
        #############
        # Rewriters #
        #############

        #TODO this could do sanity checks and warn on ractionscript syntax problems
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
            s(:ras,
              :method_definition,
              m[:method_name],
              self.process(body) # NOTE recursive on body
             )
          end
          
      end

    end

  end

end


