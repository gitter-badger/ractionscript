#def x
#  exp! { y * 2 } 
#end
class!("MyActionScriptClass") {

  # build a function definition

  function!("doSomething") {

    args! :x => :int, :y => :int
    return_type! :int

    comment! "do something awesome"
    exp! { y * ((x + y) * 2) }
#    exp! { x <= y }

  }

}
