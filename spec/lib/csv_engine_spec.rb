require './spec/shared_context/csv.rb'
require 'csv_engine'

RSpec.describe CSVEngine do
  context 'private methods' do
    describe 'find_file method' do
      let(:instance) { Class.new { extend CSVEngine } }

      it 'should not find file_path' do
        expect { instance.send(:find_file, nil) }.to raise_error(
          "File not found in path ''"
        )
      end

      it 'should not find non created file in path' do
        expect { instance.send(:find_file, '/test.csv') }.to raise_error(
          "File not found in path '/test.csv'"
        )
      end
    end
  end

  context 'Parser Class' do
    subject { CSVEngine::Parser.new(file_path: '/test.csv') }

    it 'return ArgumentError when required keys are missing' do
      expect { CSVEngine::Parser.new }.to raise_error(ArgumentError)
    end

    describe 'read' do
      include_context "csv"

      context 'file not found' do
        it 'should raise missing file error' do
          expect { subject.read }.to raise_error(
            "File not found in path '/test.csv'"
          )
        end
      end

      context 'file found' do
        let(:file_name) { 'my_file' }

        before {
          subject.instance_variable_set(:@file_path, file.path)
        }

        it 'should read file and returns counter and data' do
          expect(subject.read).to match_array([1, [{"1"=>"6", "2"=>"7", "3"=>"8", "4"=>"9", "5"=>"10"}]])
        end
      end
    end
  end
end
