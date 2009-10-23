require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "matches"
    gem.summary = %Q{A DSL for defining regular-expression-based methods in Ruby.}
    gem.description = %Q{Matches allows you to define methods that have regular 
                         expressions rather than names, and automatically
                         configires method_missing to handle them.}
    gem.email = "pncalvin@gmail.com"
    gem.homepage = "http://github.com/pnc/matches"
    gem.authors = ["Phil Calvin"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "cucumber", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "matches #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/*.rb')
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.spec_opts = ['--options', "\"spec/spec.opts\""]
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|

  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec