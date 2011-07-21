require File.dirname(__FILE__) + '/../../spec_helper'

describe SystemMetrics::Instrument::ActionView do
  include NotificationsSupport

  before(:each) do
    @instrument = SystemMetrics::Instrument::ActionView.new
  end

  describe '#handle?' do
    it 'should handle any event whose name ends with action_view' do
      @instrument.handles?(event(:name => 'recieve.action_view')).should be_true
      @instrument.handles?(event(:name => 'send.action_view')).should be_true
    end

    it 'should not handle an event whose name does not end with action_view' do
      @instrument.handles?(event(:name => 'do_something.else')).should be_false
      @instrument.handles?(event(:name => 'action_view.process_action')).should be_false
    end
  end

  describe '#ignore?' do
    it 'should always return false' do
      @instrument.ignore?(event(:name => 'process_action.action_view')).should be_false
      @instrument.ignore?(event(:name => 'start_processing.action_controller')).should be_false
    end
  end

  describe '#prepare' do
    it 'should try to replace any paths in payload values' do
      @instrument.mapped_paths['/abc123'] = 'A'
      e = event(:payload => { 
        :path => '/abc123/more/path',
        :action => 'create'
      })      
      @instrument.prepare(e)
      e.payload.should == { :path => 'A/more/path', :action => 'create' }
    end
  end
end
