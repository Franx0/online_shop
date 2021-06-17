require 'csv_engine'

namespace :data_example do
  # Instead of create a lib module which download files from Dropbox,
  # I directly create a custom rake task using default files manually downloaded
  # from Dropbox account.
  merchants_type = 'merchants'
  shoppers_type = 'shoppers'
  orders_type = 'orders'
  @default_types = [merchants_type, shoppers_type, orders_type]

  desc 'Create a default dataset from public CSV files'
  task :load, [:types, :files_path] => :environment do |task, args|
    args.with_defaults(types: @default_types)
    args.with_defaults(files_path: 'public/data_examples')
    types = selected_types(selected_types: args[:types])

    types.each do |type|
      printer(msg: "/ ### Loading #{type.capitalize} ### /")
      file_path = Rails.root.join(
                    Dir["#{args[:files_path]}/*.csv"].select{|title| title.include?(type)}&.first ||
                    "#{args[:files_path]}/#{type}.csv"
                  )
      expected_records, atts = CSVEngine::Parser.new(file_path: file_path).read
      counter = 0

      # Not the most efficient way to load multiple records into DB but the only one provided by AR, solution: execute SQL query
      expected_records.times do |i|
        if type.classify.constantize.find_or_create_by(atts[i])
          counter += 1
          printer(msg: '.', method: 'print')
        end
      end
      ActiveRecord::Base.connection.reset_pk_sequence!(type)
      printer(msg: "/ *** Loaded #{counter} #{type.capitalize}, expected #{expected_records} *** /")
    end
  end

  desc 'Clean default laoded dataset from DB'
  task :clean, [:types] => :environment do |task, args|
    args.with_defaults(types: @default_types)
    types = selected_types(selected_types: args[:types])
    types.each do |type|
      printer(msg: "/ ### Cleaning #{type.capitalize} ### /")
      # Sounds good to use delete inbuilt method but I prefer to use destroy_all to provide cascading removal
      type.classify.constantize.destroy_all
      printer(msg: "/ *** #{type.capitalize} removed *** /")
    end
  end

  def selected_types(selected_types: types)
    selected = @default_types.select{ |type| selected_types.split(' ').flatten.include?(type) }

    raise "Not valid Types provided. Example: #{@default_types}" if selected.empty?
    selected
  end

  def printer(msg:, method: 'puts')
    eval("#{method}'#{msg}'") unless Rails.env.test?
  end
end
