RSpec.describe Shopper, type: :model do
  subject { build(:shopper) }

  it "has many orders" do
    should respond_to(:orders)
  end

  it 'should have a valid factory' do
    expect(subject.valid?).to be_truthy
  end

  Shopper::VALIDATABLE_ATTS.each do |att|
    it "should be invalid with null #{att}" do
      subject[att] = nil
      expect(subject.valid?).to be_falsey
    end
  end
end
