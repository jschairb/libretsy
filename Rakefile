require 'rubygems'
require 'rake'
require 'lib/libretsy/version.rb'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "libretsy"
    gem.summary = %Q{A pure ruby client for a RETS system}
    gem.description = %Q{A pure ruby client for a RETS system focused on speed and maintainability.}
    gem.email = "joshua.schairbaum@gmail.com"
    gem.homepage = "http://github.com/jschairb/libretsy"
    gem.authors = ["Joshua Schairbaum"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_runtime_dependency "typhoeus"
    gem.version = Libretsy::VERSION
    gem.files   = FileList['lib/**/*.rb', '[A-Z]*', 'spec/**/*'].to_a
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "libretsy #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
