require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MatchMethod do
  it "should store its matcher" do
    mm = MatchMethod.new(:matcher => /foo/)
    mm.matcher.should == /foo/
  end
  
  it "should know if a message matches" do
    mm = MatchMethod.new(:matcher => /find_by_(\w+)/)
    mm.matches?('find_by_something').should be_true
  end
  
  it "should not match if the message doesn't match" do
    mm = MatchMethod.new(:matcher => /find_by_(\w+)/)
    mm.matches?('not').should be_false
  end
  
  it "should store a Proc" do
    real_proc = Proc.new {}
    mm = MatchMethod.new(:matcher => /find_by_(\w+)/, 
                        :proc => real_proc)
    mm.proc.should == real_proc
  end
  
  it "should call its Proc when a message matches" do
    mock_proc = Proc.new {}
    object = Object.new
    object.should_receive(:instance_exec).once.with('something')
    
    mm = MatchMethod.new(:matcher => /find_by_(\w+)/, 
                        :proc => mock_proc)
    mm.match(object, 'find_by_something')
  end
  
  it "should work with no groups" do
    mock_proc = Proc.new {}
    object = Object.new
    object.should_receive(:instance_exec).once.with(no_args())
    
    mm = MatchMethod.new(:matcher => /find_by_something/, 
                        :proc => mock_proc)
    mm.match(object, :find_by_something)
  end
  
  it "should pass each group in as an argument" do
    mock_proc = Proc.new {}
    object = Object.new
    object.should_receive(:instance_exec).once.with('something')
    
    mm = MatchMethod.new(:matcher => /find_by_(\w+)/, 
                        :proc => mock_proc)
    mm.match(object, :find_by_something)
  end
  
  it "should work with arguments, too" do
    mock_proc = Proc.new {}
    object = Object.new
    object.should_receive(:instance_exec).once.with('argument')
    
    mm = MatchMethod.new(:matcher => /find_by_something/, 
                        :proc => mock_proc)
    mm.match(object, :find_by_something, 'argument')
  end
  
  it "should work with both match groups and arguments" do
    mock_proc = Proc.new {}
    object = Object.new
    object.should_receive(:instance_exec).once.with('something', 'argument')
    
    mm = MatchMethod.new(:matcher => /find_by_(\w+)/, 
                        :proc => mock_proc)
    mm.match(object, :find_by_something, 'argument')
  end
end