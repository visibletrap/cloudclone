# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cloudclone/version"

Gem::Specification.new do |s|
  s.name        = "cloudclone"
  s.version     = Cloudclone::VERSION
  s.authors     = ["Nuttanart Pornprasitsakul"]
  s.email       = ["visibletrap@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Multi cloud service instances management}
  s.description = %q{Cloudclone help you easily manage tons of cloud service instances}

  s.rubyforge_project = "cloudclone"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"

  s.add_development_dependency "rspec"
  s.add_runtime_dependency "heroku"
end
