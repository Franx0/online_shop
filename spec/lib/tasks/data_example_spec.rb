require './spec/shared_context/rake.rb'
require './spec/shared_context/csv.rb'
require 'csv_engine'

describe "data_example:load", type: :rake do
  include_context "rake"

  it "should be associated with the right environment" do
    expect(subject.prerequisites).to include("environment")
  end

  context 'missing files or directories' do
    it "should not execute nothing" do
      expect { subject.invoke('test', '/test') }.to raise_error(
        'Not valid Types provided. Example: ["merchants", "shoppers", "orders"]'
      )
    end

    it "should raise missing file error" do
      expect { subject.invoke('merchants', '/test') }.to raise_error(
        "File not found in path '/test/merchants.csv'"
      )
    end
  end

  context 'files or directories found for records' do
    let(:merchants) {
      [
        ['id','name','email','cif'],
        [1,'TestName','test1@test.com','000000001'],
        [2,'TestName','test2@test.com','000000002'],
        [3,'TestName','test3@test.com','000000003']
      ]
    }

    let(:shoppers) {
      [
        ['id','name','email','nif'],
        [1,'TestName','test1@test.com','000000001'],
        [2,'TestName','test2@test.com','000000002'],
        [3,'TestName','test3@test.com','000000003']
      ]
    }

    let(:orders) {
      [
        ['id','amount','completed_at','merchant_id', 'shopper_id'],
        [1,'1.0','04/01/2018 19:08:00', create(:merchant).id, create(:shopper).id],
        [2,'3.0',nil, create(:merchant).id, create(:shopper).id],
        [3,'2.0',nil, create(:merchant).id, create(:shopper).id],
      ]
    }

    ['merchants', 'shoppers', 'orders'].each do |type|
      describe "create #{type}" do
        include_context "csv"

        let(:data) { eval(type) }
        let(:file_name) { type }

        it "should create #{type} records" do
          expect{ subject.invoke(type, 'tmp') }.to change(type.classify.constantize, :count).by(3)
        end

        it "should find but not create #{type} records" do
          subject.invoke(type, 'tmp')
          expect{ subject.invoke(type, 'tmp') }.to change(type.classify.constantize, :count).by(0)
        end
      end
    end
  end
end

describe "data_example:clean", type: :rake do
  include_context "rake"

  it "should be associated with the right environment" do
    expect(subject.prerequisites).to include("environment")
  end

  ['merchants', 'shoppers', 'orders'].each do |type|
    describe "remove #{type}" do
      it "should remove #{type} records" do
        create_list(type.singularize.to_sym, 3)
        expect{ subject.invoke(type, 'tmp') }.to change(type.classify.constantize, :count).by(-3)
      end

      it "should find but not create #{type} records" do
        expect{ subject.invoke(type, 'tmp') }.to change(type.classify.constantize, :count).by(0)
      end
    end
  end
end
