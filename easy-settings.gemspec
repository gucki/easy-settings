# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "easy-settings/version"

Gem::Specification.new do |s|
  s.name        = "easy-settings"
  s.version     = EasySettings::VERSION
  s.license     = "MIT"
  s.authors     = ["Corin Langosch"]
  s.email       = ["info@corinlangosch.com"]
  s.homepage    = "https://github.com/gucki/easy-settings"
  s.summary     = %q{Flexible yet easy handling of application settings.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.required_ruby_version = ">= 2.6"
  s.add_runtime_dependency "activesupport", ">= 3.0.0"
  s.add_development_dependency "rspec", "~> 3.4.0"
  s.add_development_dependency "debug", "~> 1.10.0"
end
