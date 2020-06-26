#
# Cookbook:: security-cookbook
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'chefspec'

describe 'security-cookbook::su-restrict-u45' do
  context 'When all attributes are default, on CentOS 6.7' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '6.7').converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end