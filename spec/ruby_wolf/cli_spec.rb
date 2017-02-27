require 'spec_helper'

describe RubyWolf::CLI do
  let(:cli) { RubyWolf::CLI.new(args) }

  before { cli.parse_options }

  describe '#run' do
    let(:args) { ['-d'] }
    let(:app_double) { double }

    context 'Rack file found' do
      before do
        allow(File).to receive(:exist?).and_return(true)
        allow(::Rack::Builder).to receive(:parse_file).and_return(app_double)
        allow_any_instance_of(RubyWolf::Server).to receive(:start)
      end

      it 'creates Rack app from the rack file' do
        cli.run
        expect(cli.app).to eql(app_double)
      end

      it 'starts ruby wolf server' do
        expect_any_instance_of(RubyWolf::Server).to receive(:start)
        cli.run
        expect(cli.server).to be_a(RubyWolf::Server)
        expect(cli.server.app).to eql(app_double)
        expect(cli.server.configs).to eq(cli.configs)
      end
    end

    context 'Rack file not found' do
      before do
        allow(File).to receive(:exist?).and_return(false)
      end

      it 'raises exception' do
        expect do
          cli.run
        end.to raise_error(/rack file not found/i)
      end
    end
  end

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
