module Ractionscript

  # singleton refs to java types which Ractionscript needs
  module JavaTypes

    module MetaAs
      Factory         = ::Rjb::import 'uk.co.badgersinfoil.metaas.ActionScriptFactory'
      CompilationUnit = ::Rjb::import 'uk.co.badgersinfoil.metaas.dom.ASCompilationUnit'
      ClassType       = ::Rjb::import 'uk.co.badgersinfoil.metaas.dom.ASClassType'
      Method          = ::Rjb::import 'uk.co.badgersinfoil.metaas.dom.ASMethod'
      Visibility      = ::Rjb::import 'uk.co.badgersinfoil.metaas.dom.Visibility'
      #= Rjb::import ''
    end

    module Util
      StringReader = ::Rjb::import 'java.io.StringReader'
      StringWriter = ::Rjb::import 'java.io.StringWriter'
    end

  end

  # some actionscript AST utilities
  module AST
    # singleton factory
    Factory = Ractionscript::JavaTypes::MetaAs::Factory.new
  end

end
