rule '.as' => ['.as.rb'] do |t|
	File.open(t.name, 'w') { |out|
	  out << Ractionscript::DSL.process( File.read( t.source ) )
	}
end
