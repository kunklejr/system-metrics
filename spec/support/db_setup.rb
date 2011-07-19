require 'active_support/core_ext'
require 'active_record'
require 'fileutils'

tmpdir = File.join(File.dirname(__FILE__), '..', '..', 'tmp')
FileUtils.mkdir(tmpdir) unless File.exist?(tmpdir)
test_db = File.join(tmpdir, 'test.db')

connection_spec = {
  :adapter => 'sqlite3',
  :database => test_db
}

# Delete any existing instance of the test database
FileUtils.rm test_db, :force => true

# Create a new test database
ActiveRecord::Base.establish_connection(connection_spec)

# ActiveRecord::Base.connection.initialize_schema_migrations_table

class CreateMeasurements < ActiveRecord::Migration
  def self.up
    create_table :system_metrics, :force => true do |t|
      t.string :name
      t.datetime :started_at
      t.string :transaction_id
      t.text :payload
      t.float :duration
      t.integer :request_id
      t.integer :parent_id
    end
  end

  def self.down
    drop_table :system_metrics
  end
end

CreateMeasurements.up

