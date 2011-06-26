module Ractionscript
  
  module Rjb

    def self.load_metaas

      #TODO platform agnostic defaults, and overrides by configuration
      #I work on this on BSD and Ubuntu so I have hard coded my environment classpaths here:
      
      platform = (`uname -a`)
      
      cp = case(platform)
        when /FreeBSD/
          %w(
          /usr/local/share/java/classes/commons-io.jar
          /root/.m2/repository/uk/co/badgersinfoil/metaas/metaas/0.9-SNAPSHOT/metaas-0.9-SNAPSHOT.jar
          /root/.m2/repository/org/antlr/antlr/3.0.1/antlr-3.0.1.jar
          /root/.m2/repository/org/antlr/antlr-runtime/3.0.1/antlr-runtime-3.0.1.jar
          )
      
          #TODO is antlr3-3.0.1+dfsg.jar actually needed?
        when /Linux/
          %w(
          /usr/share/java/antlr.jar
          /usr/share/java/commons-io.jar
          /home/blake/src/metaas-svn/target/metaas-0.9-SNAPSHOT.jar
          /usr/share/java/antlr3-3.0.1+dfsg.jar
          )
      
        else
          STDERR << "Dunno your platform, either add hard-coded classpath in around here: (#{__FILE__} line #{__LINE__})\nor implement a more generic classpath specification (oh please)"
          exit 1
      end
      
      # check that the classpath entries exist so we dont get confused by java errors
      cp.each {|jar| raise "Missing java dependency #{jar}" unless File.exist?(jar) }
      
      ENV["JAVA_HOME"] ||= "/usr/lib/jvm/java-6-openjdk"
      
      ::Rjb::load(cp.join(":"))

    end

  end

end
