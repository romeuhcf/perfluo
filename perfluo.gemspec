
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "perfluo/version"

Gem::Specification.new do |spec|
  spec.name          = "perfluo"
  spec.version       = Perfluo::VERSION
  spec.authors       = ["Romeu Fonseca"]
  spec.email         = ["romeu.hcf@gmail.com"]

  spec.summary       = %q{SOON: Write a short summary, because RubyGems requires one.}
  spec.description   = %q{SOON: Write a longer description or delete this line.}
  spec.homepage      = "http://perfluo.io"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "SOON: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-bundler"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "simplecov-vim"
  spec.add_dependency "json"
end
