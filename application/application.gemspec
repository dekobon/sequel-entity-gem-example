require File.join File.dirname(__FILE__), 'lib/application/version'

Gem::Specification.new do |s|
  s.version                  = '1.0.0'
  s.authors                  = ['Elijah Zupancic']
  s.email                    = %w(elijah@zupancic.name)
  s.summary                  = 'Example Application'

  s.require_paths            = %w(lib)
  s.files                    = `git ls-files`.split("\n") - %w(.rvmrc .gitignore Gemfile.lock)
  s.test_files               = `git ls-files -- {test,spec,features}/*`.split("\n") - `git ls-files -- {test/data}/*`.split("\n")

  s.name                     = 'example-application'
  s.required_ruby_version    = '~> 1.9.3'

# Be sure to add the entities gem and not reference it from the path in the
# Gemfile. That is for the example project only.
#  s.add_dependency             'example-entities'            '~> 1.0.0'

  s.add_development_dependency 'rake',                          '~> 10.1.0'
  s.add_development_dependency 'minitest',                      '~> 5.0.0'
  s.add_development_dependency 'minitest-reporters',            '~> 1.0.0'
  s.add_development_dependency 'builder',                       '~> 3.2.2'
  s.add_development_dependency 'rubocop',                       '~> 0.15.0'
  s.add_development_dependency 'rubocop-checkstyle_formatter',  '~> 0.0.4'
  s.add_development_dependency 'guard',                         '~> 2.2.4'
  s.add_development_dependency 'guard-minitest',                '~> 2.1.2'
  s.add_development_dependency 'guard-rubocop',                 '~> 1.0.0'
end
