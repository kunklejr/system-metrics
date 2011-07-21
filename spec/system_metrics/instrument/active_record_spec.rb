require File.dirname(__FILE__) + '/../../spec_helper'

describe SystemMetrics::Instrument::ActiveRecord do
  include NotificationsSupport

  before(:each) do
    @instrument = SystemMetrics::Instrument::ActiveRecord.new
  end

  describe '#handle?' do
    it 'should handle any event whose name ends with active_record' do
      @instrument.handles?(event(:name => 'sql.active_record')).should be_true
      @instrument.handles?(event(:name => 'arel.active_record')).should be_true
    end

    it 'should not handle an event whose name does not end with active_record' do
      @instrument.handles?(event(:name => 'do_something.else')).should be_false
      @instrument.handles?(event(:name => 'active_record.sql')).should be_false
    end
  end

  describe '#ignore?' do
    it 'should ignore all events whose payload[:sql] does not begin with SELECT, INSERT, UPDATE, or DELETE' do
      e = event(:name => 'sql.active_record', :payload => { :sql => 'SELECT * from users' })
      @instrument.ignore?(e).should be_false
      e = event(:name => 'sql.active_record', :payload => { :sql => 'INSERT into users' })
      @instrument.ignore?(e).should be_false
      e = event(:name => 'sql.active_record', :payload => { :sql => 'UPDATE users' })
      @instrument.ignore?(e).should be_false
      e = event(:name => 'sql.active_record', :payload => { :sql => 'DELETE from users' })
      @instrument.ignore?(e).should be_false
      e = event(:name => 'sql.active_record', :payload => { :sql => 'DESCRIBE users' })
      @instrument.ignore?(e).should be_true
    end
  end

  describe '#prepare' do
    it 'should replace all runs of multiple spaces and newlines in the payload[:sql] with a single space' do
      e = event(:name => 'sql.active_record', :payload => { :sql => 'SELECT *     from   users' })
      @instrument.prepare(e)
      e.payload[:sql].should == 'SELECT * from users'
    end

    it 'should remove the :connection_id from the payload' do
      e = event(:name => 'sql.active_record', :payload => { :sql => 'SELECT * from users', :connection_id => 27 })
      @instrument.prepare(e)
      e.payload.should_not include(:connection_id)
    end
  end
end
