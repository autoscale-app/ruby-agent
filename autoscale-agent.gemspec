require_relative "lib/autoscale/agent/version"

Gem::Specification.new do |spec|
  spec.name = "autoscale-agent"
  spec.version = Autoscale::Agent::VERSION
  spec.authors = ["Michael R. van Rooijen"]
  spec.email = ["support@autoscale.app"]
  spec.license = "MIT"

  spec.summary = "Provides Autoscale.app with the necessary metrics for autoscaling web and worker processes"
  spec.homepage = "https://autoscale.app"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = "https://rubydoc.info/gems/autoscale-agent"
  spec.metadata["source_code_uri"] = "https://github.com/autoscale-app/ruby-agent"
  spec.metadata["changelog_uri"] = "https://github.com/autoscale-app/ruby-agent/blob/master/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "https://github.com/autoscale-app/ruby-agent/issues"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["lib/**/*", "README.md", "CHANGELOG.md", "LICENSE"]
  spec.require_paths = ["lib"]

  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = ">= 2.7.0"
  spec.add_dependency "multi_json", "~> 1"
end
