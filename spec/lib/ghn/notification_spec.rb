require 'spec_helper'

describe Ghn::Notification do
  let(:data_issue) do
    {
      'repository' => {
        'full_name' => 'kyanny/ghn',
      },
      'subject' => {
        'url' => 'https://api.github.com/repos/kyanny/ghn/issues/13',
      }
    }
  end

  let(:data_pull_request) do
    {
      'repository' => {
        'full_name' => 'kyanny/ghn',
      },
      'subject' => {
        'url' => 'https://api.github.com/repos/kyanny/ghn/pulls/12',
      }
    }
  end

  describe '#repo' do
    subject { described_class.new(data_issue).repo }

    it { should eq 'kyanny/ghn' }
  end

  describe '#type' do
    context 'issues' do
      subject { described_class.new(data_issue).type }

      it { should eq 'issues' }
    end

    context 'pulls' do
      subject { described_class.new(data_pull_request).type }

      it { should eq 'pull' }
    end
  end

  describe '#number' do
    subject { described_class.new(data_issue).number }

    it { should eq '13' }
  end

  describe '#pull_request?' do
    context 'issues' do
      subject { described_class.new(data_issue).pull_request? }

      it { should be_false }
    end

    context 'pulls' do
      subject { described_class.new(data_pull_request).pull_request? }

      it { should be_true }
    end
  end

  describe '#to_s' do
    subject { described_class.new(data_issue).to_s }

    it { should eq 'https://github.com/kyanny/ghn/issues/13' }
  end
end
