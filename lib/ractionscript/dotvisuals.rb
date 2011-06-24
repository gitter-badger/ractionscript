
module ToDot
 def self.escape str
  str.gsub(Regexp.new("(\[<>\{\} |\])")) { "\\" + $1 }
 end
end

class String
  def to_dot_label; '\"'+ToDot::escape(self)+'\"'; end
end

#TODO could this be put in class Sexp where it belongs? I didn't write it
class Array
  def to_dot_label; "()"; end

  def to_dot_edge src, shorten
    " #{src}" + (shorten ? "" : ":#{object_id}") + " -> #{object_id};\n"
  end

  def to_dot_subgraph(o, sexp_to_highlight, is_highlighted_subexpression=false)
    return "" if nil
    ary = self[0].is_a?(Array)
    highlight = (sexp_to_highlight.to_a == self)
    highlight = true if is_highlighted_subexpression
    
    fillcolor = highlight ? 'orange' : 'lightblue' 
    # if there are no sub-sexps (self is a composition of atoms)
    shorten = !ary && self[1..-1].detect{|o| !o.is_a?(Array)} == nil
    s = " #{object_id} [label=\""
shorten = false
    if shorten
      s += self[0].to_dot_label + "\", shape=rect, fillcolor=#{fillcolor}];\n"
    else
      s += collect { |o| "<#{o.object_id}> " + o.to_dot_label }.join("|")
      s += "\", fillcolor=#{fillcolor}];\n"
    end
    s += collect {|o| o.to_dot_edge(object_id,shorten) }.join
    s += collect {|o| o.to_dot_subgraph(Sexp.new(self), sexp_to_highlight, highlight ) }.join
    s
  end
end

class Object
  def to_dot_subgraph(*x); end
  def to_dot_edge src, shorten; end
  def to_dot_label; ToDot::escape(to_s); end
  def to_dot(sexp_to_highlight = nil)
    s = "digraph G {\n"
    s += " node [shape=record style=filled fillcolor=lightblue "
    s += "fontname=Verdana height=0.15 fontsize=16.0 ];\n"
    s += to_a.to_dot_subgraph(self, sexp_to_highlight)
    s += "}\n"
  end
end 
