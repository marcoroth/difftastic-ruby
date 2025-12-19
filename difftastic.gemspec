# frozen_string_literal: true

require_relative "lib/difftastic/version"

Gem::Specification.new do |spec|
	spec.name = "difftastic"
	spec.version = Difftastic::VERSION
	spec.authors = ["Joel Drapper"]
	spec.email = ["joel@drapper.me"]

	spec.summary = "Integrate Difftastic with the RubyGems infrastructure."
	spec.homepage = "https://github.com/joeldrapper/difftastic-ruby"
	spec.license = "MIT"
	spec.required_ruby_version = ">= 3.2.0"

	spec.metadata = {
		"homepage_uri" => spec.homepage,
		"rubygems_mfa_required" => "true",
		"changelog_uri" => "https://github.com/joeldrapper/difftastic-ruby/releases",
	}

	spec.files = Dir[
		"lib/**/*",
		"LICENSE.txt",
		"README.md"
	]

	spec.bindir = "exe"

	spec.add_dependency "pretty_please"

	spec.executables << "difft"
end
