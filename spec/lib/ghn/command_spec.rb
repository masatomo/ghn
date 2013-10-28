require 'spec_helper'

describe Ghn::Command do
  describe '#initialize' do
    it 'should take one argument' do
      expect { described_class.new }.to raise_error
    end
  end

  describe '#process!' do
    context 'when no arguments is passed' do
      subject { described_class.new([]) }

      it 'should regard the omitted command is `list`' do
        expect(subject.command).to eq 'list'
      end

      it { should be_valid }
    end

    context 'when one argument is passed' do
      subject { described_class.new(['open']) }

      it 'should use given command' do
        expect(subject.command).to eq 'open'
      end

      it { should be_valid }
    end

    context 'when more than one arguments is passed' do
      subject { described_class.new(['list', 'kyanny/ghn']) }

      it 'should use given command and arguments' do
        expect(subject.command).to eq 'list'
        expect(subject.args).to eq ['kyanny/ghn']
      end

      it { should be_valid }
    end

    context 'if first argument is not proper command' do
      subject { described_class.new(['unknown']) }
      it { should_not be_valid }
    end
  end
end
