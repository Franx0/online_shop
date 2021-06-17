shared_examples_for "cacheable" do
  let(:model) { described_class }
  let(:instance) { create(model.to_s.underscore.to_sym) }

  describe "set_cache method" do
    it "create new cache key with values" do
      instance.set_cache(key: key, values: values)
      expect(Redis.current.keys).to match_array([key])
    end

    it "set up proper value with key" do
      instance.set_cache(key: key, values: values)
      expect(Redis.current.get(key)).to eql(values.to_s)
    end
  end

  describe "get_keys method" do
    it "find keys which match string" do
      instance.set_cache(key: "#{key}:test", values: 5)
      expect(instance.get_keys(key: key_matcher).last).to match_array(["#{key}:test"])
    end
  end

  describe "flush_keys method" do
    it "remove cache keys" do
      instance.set_cache(key: 'persistedKey', values: [1])
      instance.flush_keys(keys: keys)
      expect(Redis.current.keys).to match_array(['persistedKey'])
    end
  end
end
