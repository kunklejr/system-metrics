require File.dirname(__FILE__) + '/../spec_helper'

describe SystemMetrics::Config do
  it 'should be valid by default' do
    config = SystemMetrics::Config.new
    config.should be_valid
  end

  it 'should be invalid with nil instruments' do
    config = SystemMetrics::Config.new
    config.instruments = nil
    config.should_not be_valid
  end

  it 'should be invalid without a store' do
    config = SystemMetrics::Config.new
    config.store = nil
    config.should_not be_valid
  end

  it 'should be invalid with a nil path_exclude_patterns' do
    config = SystemMetrics::Config.new
    config.path_exclude_patterns = nil
    config.should_not be_valid
  end

  it 'should be invalid with a nil notification_exclude_patterns' do
    config = SystemMetrics::Config.new
    config.notification_exclude_patterns = nil
    config.should_not be_valid
  end
end
