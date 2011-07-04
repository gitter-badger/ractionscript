class!("MyActionScriptClass") {

  # declare a static const String field
  field!(:public, :static, :const, 'LABEL', 'String').init!( "foobar" )

  # build a function definition

  function!("doSomething") {

    args! :x => :int, :y => :int
    return_type! :int

    comment! "do something awesome"
    exp! { a && (b || c) && d }

#    exp! { x <= y }

  }

}
