require 'csv'

RSpec.shared_context "csv" do
  let(:data) {
    [
      [1, 2, 3, 4, 5],
      [6, 7, 8, 9, 10]
    ]
  }

  let(:file_name) { 'test' }

  let!(:file) {
    Tempfile.new([file_name, '.csv'], [tmpdir = Rails.root.join('tmp')]).tap do |f|
      data.each do |d|
        f << d.join(',') + "\r"
      end

      f.close
    end
  }

  after do
    file.unlink
  end
end
