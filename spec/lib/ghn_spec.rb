require 'spec_helper'

describe Ghn do
  let(:token) { double }
  let(:command) { double }

  describe '#initialize' do
    context 'if no arguments is passed' do
      it 'should raise error' do
        expect { described_class.new }.to raise_error
      end
    end

    context 'if token and command arguments is passed' do
      it 'should not raise error' do
        expect { described_class.new(token, command) }.to_not raise_error
      end
    end
  end

  describe '#marked' do
    subject { described_class.new(token, command).marked("https://github.com/kyanny/ghn/issues/13") }

    it 'should prepend [x] mark to notification url' do
      expect(subject).to match(/\A\[x\] /)
    end
  end
end
