
module ToDot
 def self.escape str
  str.gsub(Regexp.new("(\[<>\{\} |\])")) { "\\" + $1 }
 end
end

class String
  def to_dot_label; '\"'+ToDot::escape(self)+'\"'; end
end

class Array
  def to_dot_label; "..."; end

  def to_dot_edge src, shorten
    " #{src}" + (shorten ? "" : ":#{object_id}") + " -> #{object_id};\n"
  end

  def to_dot_subgraph
    return "" if nil
    ary = self[0].is_a?(Array)
# don't like it disabled it
    #shorten = !ary && self[1..-1].detect{|o| !o.is_a?(Array)} == nil
    shorten = false
    s = " #{object_id} [label=\""
    if shorten
      s += self[0].to_dot_label + "\", shape=rect];\n"
    else
      s += collect { |o| "<#{o.object_id}> " + o.to_dot_label }.join("|")
      s += "\"];\n"
    end
    s += collect {|o| o.to_dot_edge(object_id,shorten) }.join s += collect {|o| o.to_dot_subgraph }.join
    s
  end
end

class Object
  def to_dot_subgraph; end
  def to_dot_edge src, shorten; end
  def to_dot_label; ToDot::escape(to_s); end
  def to_dot
    s = "digraph G {\n"
    s += " node [shape=record style=filled fillcolor=lightblue "
    s += "fontname=Verdana height=0.15 fontsize=16.0 ];\n"
    s += to_a.to_dot_subgraph
    s += "}\n"
  end
end 
