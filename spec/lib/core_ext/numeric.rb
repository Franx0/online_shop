require './lib/core_ext/numeric.rb'

RSpec.describe Numeric do
  it "reponses if value is numeric type" do
    expect('100').not_to respond_to(:percent_of)
  end

  it "calculates numeric percentage" do
    expect(100.percent_of(10)).to eql(10.to_f)
  end
end
