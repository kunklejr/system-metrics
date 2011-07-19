require File.dirname(__FILE__) + '/spec_helper'
require 'system_metrics'

describe SystemMetrics do
  it 'should allow setting collection status to off' do
    SystemMetrics.collection_off
    SystemMetrics.should_not be_collecting
  end

  it 'should allow setting collection status to on' do
    SystemMetrics.collection_on
    SystemMetrics.should be_collecting
  end

  it 'should indicate whether the current status is on' do
    SystemMetrics.collection_off
    SystemMetrics.collecting?.should be_false
    SystemMetrics.collection_on
    SystemMetrics.collecting?.should be_true
  end

  it 'should allow a block of code to execute with status off' do
    SystemMetrics.collection_on
    SystemMetrics.without_collection do
      SystemMetrics.should_not be_collecting
    end
    SystemMetrics.should be_collecting
  end
end
