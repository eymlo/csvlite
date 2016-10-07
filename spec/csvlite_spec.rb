require 'spec_helper'

describe CSVlite do
  it 'has a version number' do
    expect(CSVlite::VERSION).not_to be nil
  end

  it 'run join query with 2 file' do
    query = <<-SQL
    SELECT b.* FROM a INNER JOIN b ON a.a = b.aa
    SQL

    files = ['../fixtures/a.csv', '../fixtures/b.csv'].map do |file|
      File.expand_path(file, __FILE__)
    end

    result = CSVLite.query_files(files, query)

    expect(result.count).to eql(1)
    expect(result[0][6]).to eql('expected')
  end

  it 'run join query with 2 file with instance method' do
    query = <<-SQL
    SELECT b.* FROM a INNER JOIN b ON a.a = b.aa
    SQL

    files = ['../fixtures/a.csv', '../fixtures/b.csv'].map do |file|
      File.expand_path(file, __FILE__)
    end

    subject = CSVLite.new
    subject.load_multiple(files)
    result = subject.query(query)

    expect(result.count).to eql(1)
    expect(result[0][6]).to eql('expected')
  end

end

