module Ractionscript

  module DSL
    
    module Translators

      # the point of this class, so far, is simply to re-order the
      # method definitions and their associated syntax (args and return_type)
      # so that the args and return type come after the method definition
      # this makes the code generated for args and return_type simpler
      # because they can modify the last method definition
      # (otherwise they'd have to store stuff in a temporary)
      class PostProcessor < SexpBuilder

        def initialize; super; end

        #########
        # Rules #
        #########

          rule :method_definition_containing_block do
            all(
              child(s(:ras, :method_definition, _, _)),
              t(:block)
            ) % :container
          end

        #############
        # Rewriters #
        #############
          
          # do the swizzling
          rewrite :method_definition_containing_block do |m|
            swizzle_method_definition_components(m[:container])
          end

        # do the reordering described above
        def swizzle_method_definition_components(containing_block)
          i = containing_block       # input
          o = s()                    # output
          o.push i.shift             # :block
          current_arglist     = nil
          current_return_type = nil
          i.each do |c|
            if    c[1] == :paramlist;     current_arglist     = c
            elsif c[1] == :return_type; current_return_type = c
            elsif c[1] == :method_definition
              o.push c                       # put method definition first
              o.push current_arglist if current_arglist
              o.push current_return_type if current_return_type
              current_arglist     = nil
              current_return_type = nil
            else
              #recursive, this is important
              o.push PostProcessor.new.process(c)
            end
          end
          o
        end
        
      end

    end

  end

end

