Matches – easygoing methods
===========================

Matches is an easy DSL for defining regular-expression-based methods in Ruby.

Start playing with matches:

    # If needed
    sudo gem install gemcutter
    gem tumble
    
    sudo gem install matches

Then, in a Ruby file somewhere:

    require 'rubygems'
    require 'matches'
    
    class Hippo
      def initialize
        @verbs = []
      end
      
      matches /^(\w+)\!$/ do |verb|
        @verbs << verb
      end
      
      matches /^(\w+)ed\?$/ do |verb|
        @verbs.include?(verb)
      end
    end

    herman = Hippo.new
    herman.fatten!
    herman.touch!
    
    herman.touched?
    ==> true

[Read the guide](http://wiki.github.com/pnc/matches) to learn more.