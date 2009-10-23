As a fancy-pants programmer
I want to define match methods using regular expressions
So that I don't have to screw around with method_missing

Scenario: Define a matcher method
  Given I have the following Ruby code:
  """
    class Hippo 
      matches /^(\w+)\!$/ do |verb|
        puts "I've been #{verb}ed!"
      end
    end
    
    Hippo.new.touch!
  """
  When I execute the code
  Then I should see "I've been touched!" in the output

Scenario: Another meta-method
  Given I have the following Ruby code:
  """
    class Hippo
      def initialize
        @verbs = []
      end

      matches /^(\w+)\!$/ do |verb|
        puts "Doing a #{verb}"
        @verbs << verb
      end

      matches /^(\w+)ed\?$/ do |verb|
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
  
Scenario: Defining class methods
  Given I have the following Ruby code:
  """
    class Hippo
      attr_accessor :disposition
      
      def initialize(dis)
        self.disposition = dis
      end
      
      class << self
        matches /^new_(\w+)$/ do |dis|
          new(dis)
        end
      end
    end

    herman = Hippo.new_angry

    puts herman.disposition
  """
  When I execute the code
  Then I should see "angry" in the output
  