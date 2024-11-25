# frozen_string_literal: true

require_relative "lib/poteto/version"

Gem::Specification.new do |spec|
  spec.name = "poteto"
  spec.version = Poteto::VERSION
  spec.authors = ["OPhamster"]
  spec.email = ["neel.maitra@clarisights.com"]

  spec.summary = "poteto rules"
  spec.description = "salad"
  spec.homepage = "https://github.com/ophamster/"
  spec.required_ruby_version = ">= 3.1.4"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "open3", "~> 0.1.1"
  spec.add_dependency "octokit"
  spec.add_dependency "optparse", "~> 0.2.0"
  spec.add_dependency "yaml", "~> 0.2.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
  spec.add_development_dependency "ruby-lsp"
end
