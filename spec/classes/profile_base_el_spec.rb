require 'spec_helper'
describe 'profile_base::el' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge({
            puppetversion: Puppet.version,
            :sudoversion => '1.7.10p9',
            vm_type: 'beaker'
          })
        end
        if (facts[:osfamily] == 'RedHat') then
          context "profile_base::el class without any parameters" do
            it { is_expected.to compile.with_all_deps }
            # Adding this test fixes the environment clear error that started in rspec-puppet 2.6.5
            it { is_expected.to contain_stage('last') }
          end
        end
      end
    end
  end
end
