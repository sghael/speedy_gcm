# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "speedy_gcm/version"

Gem::Specification.new do |s|
  s.name        = "speedy_gcm"
  s.version     = SpeedyGCM::VERSION
  s.authors     = ["Sandeep Ghael"]
  s.email       = ["sghael@ravidapp.com"]
  s.homepage    = "https://github.com/sghael/speedy_gcm"
  s.summary     = %q{Speedy GCM is an intelligent gem for sending push notifications to Android devices via GCM.}
  s.description = %q{Speedy GCM efficiently sends push notifications to Android devices via GCM (Google Cloud Messaging).}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
