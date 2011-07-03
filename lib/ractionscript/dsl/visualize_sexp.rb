module Ractionscript

  module DSL

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


