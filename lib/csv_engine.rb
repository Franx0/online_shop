require 'csv'

module CSVEngine
  class Parser
    include CSVEngine

    def initialize(file_path:)
      @file_path = file_path
    end

    def read
      counter = 0
      atts = []
      file = find_file(@file_path)
      # Better use ; separation on CSV files
      CSV.foreach(file, headers: :first_row, col_sep: ',', encoding: 'bom|utf-8') do |row|
        counter += 1
        atts << (Hash[row.headers.zip(row.fields)])
      end

      [counter, atts]
    end
  end

  private

  def find_file(path)
    file = path

    return file if path && File.file?(file)
    raise "File not found in path '#{path}'"
  end
end
