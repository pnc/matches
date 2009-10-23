Given /^I reset the class (.+)$/ do |klass|
  eval("#{klass}.reset_meta_methods")
end

Given /^I have the following Ruby code:$/ do |code|
  @code = code
end

When /^I execute the code$/ do
  module Kernel
    def puts(str)
      OutputStorage.write("#{str}\n")
    end
  end
  
  eval(@code)
end

Then /^I should see \"(.+)\" in the output$/ do |text|
  OutputStorage.output.should =~ /#{text}/
end

class OutputStorage
  @@output = ""
  
  def self.write(str)
    @@output += str
  end
  
  def self.output
    @@output
  end
end