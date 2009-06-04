# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{walruz}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Roman Gonzalez"]
  s.date = %q{2009-06-04}
  s.email = %q{roman@noomi.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "lib/walruz.rb",
    "lib/walruz/actor.rb",
    "lib/walruz/policy.rb",
    "lib/walruz/subject.rb",
    "lib/walruz/utils.rb",
    "rails_generators/walruz_generator.rb",
    "rails_generators/templates/admin_policy_example.rb",
    "rails_generators/templates/policies.rb",
    "rails_generators/templates/unauthorized.html",
    "rails_generators/templates/walruz_initializer.rb",
    "spec/scenario.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/walruz/actor_spec.rb",
    "spec/walruz/policy_spec.rb",
    "spec/walruz/subject_spec.rb",
    "spec/walruz/utils_spec.rb"
  ]
  s.homepage = %q{http://github.com/roman/walruz}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{walruz}
  s.rubygems_version = %q{1.3.3}
  s.summary = "Powerful and simple Authorization Framework"
  s.test_files = [
    "spec/scenario.rb",
    "spec/spec_helper.rb",
    "spec/walruz/actor_spec.rb",
    "spec/walruz/policy_spec.rb",
    "spec/walruz/subject_spec.rb",
    "spec/walruz/utils_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
