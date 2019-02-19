
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "star_ethernet/version"

Gem::Specification.new do |spec|
  spec.name          = "star_ethernet"
  spec.version       = StarEthernet::VERSION
  spec.authors       = ["Shinsuke IMAI"]
  spec.email         = ["imaishinsuke@gmail.com"]

  spec.summary       = "Star Micronics thermal printer controller via ethernet card(IFBD-HE07/08-BE07)"
  spec.description   = "This library makes it possible to print via IDBD-HE07/08-BE07 ethernet I/F Card by ruby command. According to user manual's Raw Socket Print document, this library is developed. Currently this supports only Raw Socket Print(TCP Port 9100), Gets Printer Status(TCP Port 9101) and Reset with authentication, gets settings information(TCP Port 22222)."
  spec.homepage      = "https://github.com/shinsukeimai/star_ethernet"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0.1"
  spec.add_development_dependency "rake", "~> 12.3.2"
  spec.add_development_dependency "rspec", "~> 3.8.0"
end
