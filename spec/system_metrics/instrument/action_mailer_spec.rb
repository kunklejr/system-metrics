require File.dirname(__FILE__) + '/../../spec_helper'

describe SystemMetrics::Instrument::ActionMailer do
  include NotificationsSupport

  before(:each) do
    @instrument = SystemMetrics::Instrument::ActionMailer.new
  end

  describe '#handle?' do
    it 'should handle any event whose name ends with action_mailer' do
      @instrument.handles?(event(:name => 'recieve.action_mailer')).should be_true
      @instrument.handles?(event(:name => 'send.action_mailer')).should be_true
    end

    it 'should not handle an event whose name does not end with action_mailer' do
      @instrument.handles?(event(:name => 'do_something.else')).should be_false
      @instrument.handles?(event(:name => 'action_mailer.process_action')).should be_false
    end
  end

  describe '#ignore?' do
    it 'should always return false' do
      @instrument.ignore?(event(:name => 'process_action.action_mailer')).should be_false
      @instrument.ignore?(event(:name => 'start_processing.action_controller')).should be_false
    end
  end

  describe '#prepare' do
    it 'should should keep all payload attributes except :mail' do
      e = event(:payload => { 
        :controller => 'User',
        :action => 'create',
        :mail => 'big long message'
      })      
      @instrument.prepare(e)
      e.payload.keys.should =~ [:controller, :action]
    end
  end
end
