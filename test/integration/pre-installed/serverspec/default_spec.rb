require 'spec_helper'

RSpec.describe 'default' do
  describe package('nrsysmond') do
    it { should be_installed }
  end

  describe service('nrsysmond') do
    it { should be_enabled }
  end
end
