# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{walruz}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Roman Gonzalez"]
  s.date = %q{2009-06-17}
  s.email = %q{roman@noomi.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "examples/rails/README",
    "examples/rails/Rakefile",
    "examples/rails/app/controllers/application_controller.rb",
    "examples/rails/app/helpers/application_helper.rb",
    "examples/rails/app/models/beatle.rb",
    "examples/rails/app/models/colaboration.rb",
    "examples/rails/app/models/song.rb",
    "examples/rails/config/boot.rb",
    "examples/rails/config/database.yml",
    "examples/rails/config/environment.rb",
    "examples/rails/config/environments/development.rb",
    "examples/rails/config/environments/production.rb",
    "examples/rails/config/environments/test.rb",
    "examples/rails/config/initializers/backtrace_silencers.rb",
    "examples/rails/config/initializers/inflections.rb",
    "examples/rails/config/initializers/mime_types.rb",
    "examples/rails/config/initializers/new_rails_defaults.rb",
    "examples/rails/config/initializers/session_store.rb",
    "examples/rails/config/initializers/walruz_initializer.rb",
    "examples/rails/config/locales/en.yml",
    "examples/rails/config/routes.rb",
    "examples/rails/db/development.sqlite3",
    "examples/rails/db/migrate/20090604201506_create_beatles.rb",
    "examples/rails/db/migrate/20090604201512_create_songs.rb",
    "examples/rails/db/migrate/20090604201527_create_colaborations.rb",
    "examples/rails/db/schema.rb",
    "examples/rails/db/test.sqlite3",
    "examples/rails/doc/README_FOR_APP",
    "examples/rails/lib/tasks/rspec.rake",
    "examples/rails/lib/walruz/policies.rb",
    "examples/rails/lib/walruz/policies/author_policy.rb",
    "examples/rails/lib/walruz/policies/colaboration_policy.rb",
    "examples/rails/log/development.log",
    "examples/rails/log/production.log",
    "examples/rails/log/server.log",
    "examples/rails/log/test.log",
    "examples/rails/public/404.html",
    "examples/rails/public/422.html",
    "examples/rails/public/500.html",
    "examples/rails/public/favicon.ico",
    "examples/rails/public/images/rails.png",
    "examples/rails/public/index.html",
    "examples/rails/public/javascripts/application.js",
    "examples/rails/public/javascripts/controls.js",
    "examples/rails/public/javascripts/dragdrop.js",
    "examples/rails/public/javascripts/effects.js",
    "examples/rails/public/javascripts/prototype.js",
    "examples/rails/public/robots.txt",
    "examples/rails/public/unathorized.html",
    "examples/rails/script/about",
    "examples/rails/script/autospec",
    "examples/rails/script/console",
    "examples/rails/script/dbconsole",
    "examples/rails/script/destroy",
    "examples/rails/script/generate",
    "examples/rails/script/performance/benchmarker",
    "examples/rails/script/performance/profiler",
    "examples/rails/script/plugin",
    "examples/rails/script/runner",
    "examples/rails/script/server",
    "examples/rails/script/spec",
    "examples/rails/script/spec_server",
    "examples/rails/spec/fixtures/beatles.yml",
    "examples/rails/spec/fixtures/colaborations.yml",
    "examples/rails/spec/fixtures/songs.yml",
    "examples/rails/spec/models/beatle_spec.rb",
    "examples/rails/spec/models/colaboration_spec.rb",
    "examples/rails/spec/models/song_spec.rb",
    "examples/rails/spec/rcov.opts",
    "examples/rails/spec/spec.opts",
    "examples/rails/spec/spec_helper.rb",
    "examples/rails/test/performance/browsing_test.rb",
    "examples/rails/test/test_helper.rb",
    "lib/walruz.rb",
    "lib/walruz/actor.rb",
    "lib/walruz/policy.rb",
    "lib/walruz/subject.rb",
    "lib/walruz/utils.rb",
    "rails_generators/walruz_generator.rb",
    "rails_generators/walruz_policy_generator.rb",
    "rails_generators/templates/policy.rb",
    "rails_generators/templates/policy_spec.rb",
    "rails_generators/templates/policy_test.rb",
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
  s.summary = %q{Simple but Powerful Authorization Framework}
  s.test_files = [
    "spec/scenario.rb",
    "spec/spec_helper.rb",
    "spec/walruz/actor_spec.rb",
    "spec/walruz/policy_spec.rb",
    "spec/walruz/subject_spec.rb",
    "spec/walruz/utils_spec.rb",
    "examples/rails/app/controllers/application_controller.rb",
    "examples/rails/app/helpers/application_helper.rb",
    "examples/rails/app/models/beatle.rb",
    "examples/rails/app/models/colaboration.rb",
    "examples/rails/app/models/song.rb",
    "examples/rails/config/boot.rb",
    "examples/rails/config/environment.rb",
    "examples/rails/config/environments/development.rb",
    "examples/rails/config/environments/production.rb",
    "examples/rails/config/environments/test.rb",
    "examples/rails/config/initializers/backtrace_silencers.rb",
    "examples/rails/config/initializers/inflections.rb",
    "examples/rails/config/initializers/mime_types.rb",
    "examples/rails/config/initializers/new_rails_defaults.rb",
    "examples/rails/config/initializers/session_store.rb",
    "examples/rails/config/initializers/walruz_initializer.rb",
    "examples/rails/config/routes.rb",
    "examples/rails/db/migrate/20090604201506_create_beatles.rb",
    "examples/rails/db/migrate/20090604201512_create_songs.rb",
    "examples/rails/db/migrate/20090604201527_create_colaborations.rb",
    "examples/rails/db/schema.rb",
    "examples/rails/lib/walruz/policies/author_policy.rb",
    "examples/rails/lib/walruz/policies/colaboration_policy.rb",
    "examples/rails/lib/walruz/policies.rb",
    "examples/rails/spec/models/beatle_spec.rb",
    "examples/rails/spec/models/colaboration_spec.rb",
    "examples/rails/spec/models/song_spec.rb",
    "examples/rails/spec/spec_helper.rb",
    "examples/rails/test/performance/browsing_test.rb",
    "examples/rails/test/test_helper.rb"
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
