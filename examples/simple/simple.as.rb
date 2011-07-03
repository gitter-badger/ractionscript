class!("MyActionScriptClass") {

  # build a function definition

  function!("doSomething") {

    args! :x => :int, :y => :int
    return_type! :int

    comment! "do something awesome"
    exp! 'x + y'

  }

  # with the full power of ruby!
  3.times do |i|

    function!("doSomething#{i}") {

      args! :x => :int, :y => :int
      return_type! :int

      comment! "return x plus y times some compile time constant"
      exp! "return(x + y * #{i})"

    }

  end

}
