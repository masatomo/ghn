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
end
