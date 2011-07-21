require File.dirname(__FILE__) + '/../../spec_helper'

describe SystemMetrics::Instrument::Rack do
  include NotificationsSupport

  before(:each) do
    @instrument = SystemMetrics::Instrument::Rack.new
  end

  describe '#handle?' do
    it 'should handle any event whose name is request.rack' do
      @instrument.handles?(event(:name => 'request.rack')).should be_true
    end

    it 'should not handle an event whose name is not request.rack' do
      @instrument.handles?(event(:name => 'response.rack')).should be_false
      @instrument.handles?(event(:name => 'view.rack')).should be_false
    end
  end

  describe '#ignore?' do
    it 'should always return false' do
      @instrument.ignore?(event(:name => 'request.rack')).should be_false
      @instrument.ignore?(event(:name => 'start_processing.action_controller')).should be_false
    end
  end

end
