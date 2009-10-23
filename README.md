meta_def
========

`meta_def` is a helper for defining intelligent meta-methods in Ruby.

For instance, you could define a method like this:

    class Hippo
      def initialize
        @verbs = []
      end
      
      meta_def /(\w+)\!/ do |verb|
        @verbs << verb
      end
      
      meta_def /(\w+)ed\?/ do |verb|
        @verbs.include?(verb)
      end
    end

    herman = Hippo.new
    herman.fatten!
    herman.touch!
    
    herman.touched?
    ==> true

