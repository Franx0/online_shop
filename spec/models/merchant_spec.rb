RSpec.describe Merchant, type: :model do
  subject { build(:merchant) }

  it "has many orders" do
    should respond_to(:orders)
  end

  it 'should have a valid factory' do
    expect(subject.valid?).to be_truthy
  end

  Merchant::VALIDATABLE_ATTS.each do |att|
    it "should be invalid with null #{att}" do
      subject[att] = nil
      expect(subject.valid?).to be_falsey
    end
  end

  describe 'disbursements method' do
    it "should return empty disbursements if not disbursements" do
      expect(subject.disbursements).to eql({})
    end

    it "should return empty disbursements if disbursements created but not in date provided" do
      subject.save!
      subject.set_cache(
        key: "disbursements:merchants:#{subject.id}",
        values: {DateTime.now.strftime('%Y-%m-%d') => 3}.to_json
      )
      expect(subject.disbursements(date: (DateTime.now + 7.days).beginning_of_week)).to eql({subject.id => {}})
    end

    it "should return all disbursements if disbursements created and date not provided" do
      subject.save!
      subject.set_cache(
        key: "disbursements:merchants:#{subject.id}",
        values: {DateTime.new(2016,5,17).beginning_of_week.strftime('%Y-%m-%d') => 3}.to_json
      )
      expect(subject.disbursements).to eql({subject.id => {DateTime.new(2016,5,17).beginning_of_week.strftime('%Y-%m-%d') => 3}})
    end

    it "should return dated disbursements if disbursements created and date provided" do
      subject.save!
      subject.set_cache(
        key: "disbursements:merchants:#{subject.id}",
        values: {
          DateTime.new(2018,5,17).beginning_of_week.strftime('%Y-%m-%d') => 1,
          DateTime.new(2016,5,17).beginning_of_week.strftime('%Y-%m-%d') => 3
        }.to_json
      )

      expect(subject.disbursements(date: DateTime.new(2016,5,17).beginning_of_week)).to eql({subject.id => {DateTime.new(2016,5,17).beginning_of_week.strftime('%Y-%m-%d') => 3}})
    end
  end
end
