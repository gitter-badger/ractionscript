module Ractionscript

  # some s-expression utilities
  module Sexp

    def self.ruby_string_to_sexp(ruby)
      sexp = RubyParser.new.parse(ruby)
      Unifier.new.process(sexp)
    end

    def self.viz_sexp(sexp, sexp_path_query=nil, match_key=:highlight)
      #TODO support highlighting more than one match
      sexp_path_match = ((sexp / sexp_path_query)[0][match_key] rescue nil)
      xsl_file = File.join( File.dirname(__FILE__), 'graphviz', 'notugly.xsl' )
      File.open("./output.tmp", "w") { |f| f.write sexp.to_dot(sexp_path_match) }
      `dot -Tsvg output.tmp > output.tmp.svg`
      `xsltproc #{xsl_file} output.tmp.svg > output.notugly.svg`
      `rm -f output.tmp output.tmp.svg`
      system "rsvg-view -k output.notugly.svg &"
    end

  end

end
