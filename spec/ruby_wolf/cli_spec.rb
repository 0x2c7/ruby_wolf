require 'spec_helper'

describe RubyWolf::CLI do
  let(:cli) { RubyWolf::CLI.new(args) }

  before { cli.parse_options }

  describe '#parse_options' do
    describe 'daemon option' do
      context 'short form' do
        let(:args) { ['-d'] }
        it { expect(cli.configs[:daemon]).to eql(true) }
      end

      context 'full form' do
        let(:args) { ['--daemon'] }
        it { expect(cli.configs[:daemon]).to eql(true) }
      end
    end

    describe 'port option' do
      context 'short form' do
        let(:args) { ['-p 5000'] }
        it { expect(cli.configs[:port]).to eql(5000) }
      end

      context 'full form' do
        let(:args) { ['--port=5000'] }
        it { expect(cli.configs[:port]).to eql(5000) }
      end
    end
  end
end
