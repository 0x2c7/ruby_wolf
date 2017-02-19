require 'spec_helper'

describe RubyWolf::Configuration do
  let(:configs) { RubyWolf::Configuration.new }

  describe '[]=' do
    context 'key not exists' do
      before do
        configs[:hihi] = 'Test'
      end

      it 'store the value under the key' do
        expect(configs[:hihi]).to eql('Test')
      end
    end

    context 'key exists' do
      before do
        configs[:hihi] = 'Test'
        configs[:hihi] = 'or not to test'
      end

      it 'updates the value under the key' do
        expect(configs[:hihi]).to eql('or not to test')
      end
    end
  end

  describe '[]' do
    context 'key exists' do
      before do
        configs[:hihi] = 'What'
      end

      it 'returns the value under the key' do
        expect(configs[:hihi]).to eql('What')
      end
    end

    context 'key not exists' do
      it 'returns nil' do
        expect(configs[:not_exist]).to eql(nil)
      end
    end
  end
end
