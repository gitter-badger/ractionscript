rule '.as3' => ['.as3.rb'] do |t|
	File.open(t.name, 'w') { |out|
	  out << Ractionscript::DSL.process(t.source)
	}
end
