require './spec/models/concerns/cacheable'

RSpec.describe Order, type: :model do
  subject { build(:order) }

  it_behaves_like "cacheable" do
    let(:key_matcher) { 'myKey*' }
    let(:key) { 'myKey' }
    let(:keys) { ['myKey', 'myAnotherKey'] }
    let(:values) { [1, 2, 3, 4] }
  end

  it "belongs to merchant" do
    should respond_to(:merchant)
  end

  it "belongs to shopper" do
    should respond_to(:shopper)
  end

  it 'should have a valid factory' do
    expect(subject.valid?).to be_truthy
  end

  describe 'amount attribute' do
    it 'should be invalid with amount lower than zero' do
      subject.amount = -1.to_f
      expect(subject.valid?).to be_falsey
    end

    it 'should be invalid with amount null' do
      subject.amount = nil
      expect(subject.valid?).to be_falsey
    end
  end

  describe 'fee calculation' do
    it 'should return 1% if amount < 50EUR' do
      subject.amount = 49.to_f
      expect(subject.calculate_fee).to eql(subject.amount.percent_of(1))
    end

    it 'should return 0.95% if amount between 50EUR - 300EUR' do
      subject.amount = 51.to_f
      expect(subject.calculate_fee).to eql(subject.amount.percent_of(0.95))
    end

    it 'should return 0.85% if amount > 300EUR' do
      subject.amount = 301.to_f
      expect(subject.calculate_fee).to eql(subject.amount.percent_of(0.85))
    end
  end

  context 'private methods' do
    describe 'set_disbursement method' do
      let(:order) { build(:order, amount: 100) }

      it 'should set_disbursement method before create' do
        expect { order.save }.to change(order, :disbursement)
                             .from(0.0)
                             .to(order.amount - order.calculate_fee)
      end

      it 'should set_fee method before create' do
        expect { order.save }.to change(order, :fee)
                             .from(0.0)
                             .to(order.calculate_fee)
      end
    end
  end
end