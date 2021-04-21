require_relative 'lib/qube/version'

Gem::Specification.new do |spec|
  spec.name          = 'qube'
  spec.version       = Qube::VERSION
  spec.authors       = ["Sergey Fedorov"]
  spec.email         = ["creadone@gmail.com"]

  spec.summary       = %q{Tarantool Queue client for Ruby}
  spec.description   = %q{Ruby HTTP-client for the Message Queue based on Tarantool}
  spec.homepage      = "https://github.com/tnt-qube/qube-ruby"

  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.add_runtime_dependency 'net-http-persistent', '~> 3.1.0'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ["lib"]
end
