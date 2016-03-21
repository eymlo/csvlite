require_relative "./csvlite/version"
require 'csv'
require 'sqlite3'
require 'byebug'

class CSVLite
  attr_reader :db

  def initialize(db = nil)
    if db.nil?
      @db = SQLite3::Database.new(':memory:')
    else
      raise "Not SQLite 3 DB" unless db.is_a? SQLite3::Database
      @db = db
    end
  end

  def load_from_csv_file(table_name, csv_file)
    rows = CSV.read(csv_file)
    header = rows.shift
    create_statement = _build_table_schema(table_name, header, rows)
    @db.execute create_statement
    _bulk_insert(table_name, header, rows)

    @db
  end

  def query(query)
    @db.execute query
  end

  def self.query_files(csv_files, query)
    lite = CSVLite.new

    [csv_files].flatten.each do |file|
      extn = File.extname  file
      name = File.basename file, extn
      lite.load_from_csv_file(name, file)
    end

    lite.query(query)
  end

  private

  def _bulk_insert(table_name, header, rows)
    rows.map do |row|
      @db.execute "INSERT INTO #{table_name} VALUES (#{header.count.times.map { |x| "?" }.join ', '})", row
    end
  end

  BASE_COLUMN_LENGTH = 256

  def _build_table_schema(table_name, header, rows)
    column_lengths = []
    rows.each do |row|
      row.each_with_index do |field, index|
        column_lengths[index] ||= 0
        column_lengths[index] = [column_lengths[index], field.length].max
      end
    end

    query = "CREATE TABLE #{table_name} (\r\n"
    query += header.map.with_index do |field, i|
      "'#{field}' VARCHAR(#{(column_lengths[i] / BASE_COLUMN_LENGTH.to_f).ceil * BASE_COLUMN_LENGTH})"
    end.join(",\r\n")

    query += "\r\n)"
  end
end

