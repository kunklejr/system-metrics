require File.dirname(__FILE__) + '/../../spec_helper'

describe SystemMetrics::Instrument::ActionController do
  include NotificationsSupport

  before(:each) do
    @instrument = SystemMetrics::Instrument::ActionController.new
  end

  describe '#handle?' do
    it 'should handle any event whose name ends with action_controller' do
      @instrument.handles?(event(:name => 'process_action.action_controller')).should be_true
      @instrument.handles?(event(:name => 'do_something.action_controller')).should be_true
    end

    it 'should not handle an event whose name does not end with action_controller' do
      @instrument.handles?(event(:name => 'do_something.else')).should be_false
      @instrument.handles?(event(:name => 'action_controller.process_action')).should be_false
    end
  end

  describe '#ignore?' do
    it 'should ignore all events unless the name is process_action.action_controller' do
      @instrument.ignore?(event(:name => 'process_action.action_controller')).should be_false
      @instrument.ignore?(event(:name => 'start_processing.action_controller')).should be_true
    end
  end

  describe '#prepare' do
    it 'should add an endpoint entry to the payload' do
      e = event(:payload => { :controller => 'User', :action => 'create' })      
      @instrument.prepare(e)
      e.payload.should include(:end_point)
      e.payload[:end_point].should == 'User#create'
    end

    it 'should remove all payload keys except :path, :method, :params, :db_runtime, :view_runtime, and :end_point' do
      e = event(:payload => { 
        :controller => 'User',
        :action => 'create',
        :path => '/',
        :method => 'GET',
        :params => {},
        :db_runtime => 10,
        :view_runtime => 10 
      })      
      @instrument.prepare(e)
      e.payload.keys.should =~ [:path, :method, :params, :db_runtime, :view_runtime, :end_point]
    end
  end
end
