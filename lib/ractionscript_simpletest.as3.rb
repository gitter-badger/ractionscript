# this is how ractionscript source might look

clasS("MyActionScriptClass") {

  args :x   => :int,
       :y   => :int,
       :z   => nil,
       :all => :rest
  returN :int
  function("mySoonToBeActionScriptFunction#{n}") { 
    #this should become actionscript
    exp! { x = (y + 3) * 2 }
    #this should still be ruby
    x = (y + 3) * 2
  }

}
