require File.dirname(__FILE__) + '/../spec_helper'
require 'system_metrics/config'

describe SystemMetrics::Config do
  it 'should be valid with instruments, path_exclude_patterns, and a store' do
    config = SystemMetrics::Config.new({:instruments => [Object.new], :store => Object.new})
    config.should be_valid
  end

  it 'should be invalid without instruments' do
    config = SystemMetrics::Config.new({:store => Object.new})
    config.should_not be_valid
  end

  it 'should be invalid without a store' do
    config = SystemMetrics::Config.new({:instruments => [Object.new]})
    config.should_not be_valid
  end

  it 'should be invalid if passed an unrecognized option' do
    config = SystemMetrics::Config.new({:instruments => [Object.new], :path_exclude_patterns => [], :store => Object.new, :bogus => true})
    config.should_not be_valid
  end
end
