require 'rubygems'
require 'matches'

class Hippo
  def normal
    puts "Just a normal method."
  end
  
  matches /^(\w+)\!$/ do |verb, adverb|
    puts "I've been #{verb}ed #{adverb}!"
  end
end

herman = Hippo.new
herman.normal
herman.touch!('gracefully')
herman.touch!('lovingly')
herman.kill!('harshly')