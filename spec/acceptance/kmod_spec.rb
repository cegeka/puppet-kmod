require 'spec_helper_acceptance'

describe 'kmod' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
        modprobe { 'floppy': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
    describe kernel_module('floppy') do
      it { should be_loaded }
    end
  end
end
