# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activejob/dispatch_rider/version'

Gem::Specification.new do |spec|
  spec.name          = "activejob-dispatch_rider"
  spec.version       = ActiveJob::DispatchRider::VERSION
  spec.authors       = ["Ronald Maravilla", "Fred Baa"]
  spec.email         = ["more.ron.too@gmail.com", "frederickbaa@gmail.com"]
  spec.summary       = %q{'ActiveJob::DispatchRider' adds `DispatchRider` support for `ActiveJob`.}
  spec.description   = %q{'ActiveJob::DispatchRider' adds `DispatchRider` support for `ActiveJob`.}
  spec.homepage      = "https://github.com/payrollhero/activejob-dispatch_rider"
  spec.license       = "BSD-3-Clause"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activejob", '~> 5.2.0'
  spec.add_dependency "dispatch-rider", "~> 1.7"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
end
