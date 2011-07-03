module Ractionscript

  module DSL

    # returns the sexp unchanged
    # but executes dot and rsvg-view to show you the s-expression graphically
    class VisualizeSexp < SexpBuilder

      attr_accessor :highlight

      def initialize(highlight = nil)
        @highlight = highlight
      end

      def process(sexp)
        system "killall rsvg-view"  # temp, convenient for me
        Ractionscript::Sexp.viz_sexp(sexp, @highlight)
        sexp
      end

    end
    
  end

end


