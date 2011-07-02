# build a class definition
class!("MyActionScriptClass") {

  # build a function definition
  args! :x => :int,
        :y => :int

  return_type!(:int)

  function!("doSomething") {
    comment! "do something awesome"
    exp! 'x + y'
  }

  # with the full power of ruby!
  3.times do |i|

    args! :x => :int,
          :y => :int

    return_type!(:int)

    function!("doSomething#{i}") {
      comment! "return x plus y times some compile time constant"
      exp! "return(x + y * #{i})"
    }

  end

}
