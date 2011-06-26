# this is how ractionscript source might look

class!("MyActionScriptClass") {

  args! :x => :int,
        :y => :int

  return_type!(:int)

  function!("doSomething") {

    return!(
      exp!( x + y )
    )

  }

}

#  args :x            => :int,
#       :y            => type_for_something(),
#       :z            => nil,
#       name_of_sth() => nil,
#       :all          => :rest
#  returN :int
#  function("mySoonToBeActionScriptFunction#{n}") { 
#    #this should become actionscript
#    exp! { x = (y + 3) * 2 }
#    #this should still be ruby
#    #x = (y + 3) * 2
#  }
