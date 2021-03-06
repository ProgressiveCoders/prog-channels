# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prog/channels/version'

Gem::Specification.new do |spec|
  spec.name          = "prog-channels"
  spec.version       = Prog::Channels::VERSION
  spec.authors       = ["Ryan T. Hosford"]
  spec.email         = ["tad.hosford@gmail.com"]

  spec.summary       = %q{ Slack / Airtable integration, parses slack channel info }
  spec.description   = %q{ Pull channels from slack, integrate with airtable }
  spec.homepage      = "https://github.com/ProgressiveCoders/prog-channels"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = ""
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|Gemfile\.lock)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "pay_dirt"

  spec.add_dependency "dotenv"
  spec.add_dependency "airrecord", "~> 1.0.1"
  spec.add_dependency "slack-ruby-client", "~> 0.13.1"
  spec.add_dependency "rake", "~> 10.0"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "minitest", "~> 5.11.3"
end
