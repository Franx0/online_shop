RSpec.shared_examples "controller status response" do |http_status|
  it "should return #{http_status} response" do
    expect(response).to have_http_status(http_status)
  end
end

RSpec.shared_examples "controller data format response" do |key|
  it "should return proper response format" do
    expect(json_response).to have_key(key)
  end
end

RSpec.shared_examples "controller format response" do |collection, key, atts|
  it "should return proper response format" do
    if collection
      keys = json_response["data"].map{ |data| data[key].keys }.uniq.flatten
    else
      keys = json_response["data"][key].keys
    end

    expect(keys).to match_array(atts)
  end
end

RSpec.shared_examples "controller error format response" do |model, key, messages|
  it "should return #{model} errors" do
    expect(json_response["errors"][key]).to match_array(messages)
  end
end

RSpec.shared_examples "controller object format response" do |type, key, definition|
  it "should return #{definition}" do
    expect(json_response[key].class).to eql(type)
  end
end
