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
            #it { is_expected.to contain_stage('last') }
          end
        end
      end
    end
  end
end
