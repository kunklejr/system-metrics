require File.dirname(__FILE__) + '/../../spec_helper'

describe SystemMetrics::Instrument::Base do
  include NotificationsSupport

  describe '#handle?' do
    it 'should handle any event whose name matches the pattern passed to the constructor' do
      instrument = SystemMetrics::Instrument::Base.new(/action_mailer$/)
      instrument.handles?(event(:name => 'recieve.action_mailer')).should be_true
      instrument = SystemMetrics::Instrument::Base.new(/action_controller$/)
      instrument.handles?(event(:name => 'process_action.action_controller')).should be_true
    end

    it 'should not handle an event whose name does not match the pattern passed to the constructor' do
      instrument = SystemMetrics::Instrument::Base.new(/action_mailer$/)
      instrument.handles?(event(:name => 'action_mailer.receive')).should be_false
      instrument = SystemMetrics::Instrument::Base.new(/action_controller$/)
      instrument.handles?(event(:name => 'action_controller.go')).should be_false
    end
  end

  describe '#ignore?' do
    it 'should always return false' do
      instrument = SystemMetrics::Instrument::Base.new(/action_mailer$/)
      instrument.ignore?(event(:name => 'process_action.action_mailer')).should be_false
      instrument.ignore?(event(:name => 'start_processing.action_controller')).should be_false
    end
  end

  describe '#prune_path' do
    it 'should allow path elements to be replaced' do
      instrument = SystemMetrics::Instrument::Base.new(/action_mailer$/)
      instrument.mapped_paths['/abc123'] = 'A'
      instrument.prune_path('/abc123/more/path').should == 'A/more/path'
    end
  end

end
