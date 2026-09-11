
Gem::Specification.new do |spec|
  spec.name          = "xlsx_templater"
  spec.version       = "0.0.1"
  spec.authors       = ["ashigirl96"]
  spec.email         = ["reon@mma.cs.tsukuba.ac.jp"]

  spec.summary       = %q{excel}
  spec.description   = %q{excel}
  spec.homepage      = 'https://github.com/ashigirl96/ruby-xlsx-templater'
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = ""

  spec.metadata["homepage_uri"] = 'https://github.com/ashigirl96/ruby-xlsx-templater'
  spec.metadata["source_code_uri"] = 'https://github.com/ashigirl96/ruby-xlsx-templater'
  spec.metadata["changelog_uri"] = 'https://github.com/ashigirl96/ruby-xlsx-templater/README'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency('rubyzip', '>= 1.1.1')
end
