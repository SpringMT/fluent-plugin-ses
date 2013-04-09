# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-ses"
  gem.version       = "0.0.3"
  gem.authors       = ["Spring_MT"]
  gem.email         = ["today.is.sky.blue.sky@gmail.com"]
  gem.summary       = %q{Fluent output plugin for AWS SES}
  gem.homepage      = "https://github.com/SpringMT/fluent-plugin-ses"

  gem.rubyforge_project = "fluent-plugin-ses"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "fluentd"
  gem.add_runtime_dependency "fluent-mixin-plaintextformatter"
  gem.add_runtime_dependency "aws-sdk"
  gem.description = <<description
Fluent output plugin for AWS SES
description
end
