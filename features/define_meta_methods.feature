As a fancy-pants programmer
I want to define meta-methods using regular expressions
So that I don't have to screw around with method_missing

Scenario: Define a meta-method
  Given I have the following Ruby code:
  """
    class Hippo 
      meta_def /(\w+)\!/ do |verb|
        puts "I've been #{verb}ed!"
      end
    end
    
    Hippo.new.touch!
  """
  When I execute the code
  Then I should see "I've been touched!" in the output

Scenario: Another meta-method
  Given I reset the class Hippo
  Given I have the following Ruby code:
  """
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

    puts herman.touched?
  """
  When I execute the code
  Then I should see "true" in the output