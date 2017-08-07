require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

RSpec.configure do |c|
  c.tty = true
  c.mock_framework = :rspec
  c.mock_with(:rspec)
  c.after(:suite) do
    RSpec::Puppet::Coverage.report!(95)
  end
end

# put local configuration and setup into spec_helper_local
begin
  require 'spec_helper_local' if File.exists?(File.join(File.dirname(__FILE__),'spec_helper_local.rb'))
rescue LoadError => e
  handle_error(e)
end
