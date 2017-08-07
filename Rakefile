require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet_blacksmith/rake_tasks' if Bundler.rubygems.find_name('puppet-blacksmith').any?

PuppetLint.configuration.log_format = '%{path}:%{line}:%{check}:%{KIND}:%{message}'
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('relative')
PuppetLint.configuration.send('disable_140chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')
PuppetLint.configuration.send('disable_trailing_comma')

exclude_paths = %w(
  pkg/**/*
  vendor/**/*
  .vendor/**/*
  bundle/**/*
  .bundle/**/*
  spec/**/*
)

Rake::Task[:lint].clear

PuppetLint::RakeTask.new :lint do |config|
  # Pattern of files to ignore
  config.ignore_paths = exclude_paths

  # Should puppet-lint prefix it's output with the file being checked,
  # defaults to true
  config.with_filename = false

  # Should the task fail if there were any warnings, defaults to false
  config.fail_on_warnings = true

  # Format string for puppet-lint's output (see the puppet-lint help output
  # for details
  config.log_format = '%{path}:%{line}:%{check}:%{KIND}:%{message}'

  # Print out the context for the problem, defaults to false
  config.with_context = true

  # Enable automatic fixing of problems, defaults to false
  config.fix = false

  # Show ignored problems in the output, defaults to false
  config.show_ignored = true

  # Compare module layout relative to the module root
  config.relative = true
end

PuppetSyntax.exclude_paths = exclude_paths

desc 'Run acceptance tests'
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc 'Populate CONTRIBUTORS file'
task :contributors do
  system("git log --format='%aN' | sort -u > CONTRIBUTORS")
end

Rake::Task['release_checks'].enhance do
  Rake::Task['check:symlinks'].clear
end


desc 'Run tests metadata_lint, release_checks'
task test: [
  :metadata_lint,
  :release_checks,
]

desc "Outputs a change log based on git tags"
task :changelog do
  init_tags = Dir['.git/refs/tags/*'].each.with_object({}) do |path, hsh|
    hsh[File.basename(path)] = File.read(path).chomp
  end

  tags = Hash[ init_tags.sort_by{|v, hash| Gem::Version.new(v)} ]

  tag_outputs = []
  tags.reduce(nil) do |(_, commit1), (name, commit2)|
    tag_date = `git log -1 --format="%ci" #{commit2}`.chomp
    lines = [ "## #{name} - #{tag_date}\n" ]
    if commit1
      lines << `git log #{commit1}...#{commit2} --pretty=" * (%h) %s [%an]"`
    end

    tag_outputs << lines.join("\n")
    [name, commit2]
  end
  File.open('CHANGELOG.md','w') do |s|
    s.puts tag_outputs.reverse.join("\n")
  end
end
