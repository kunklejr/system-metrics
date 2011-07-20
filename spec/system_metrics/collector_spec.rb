require File.dirname(__FILE__) + '/../spec_helper'

describe SystemMetrics::Collector do
  before(:each) do
    @store = TestStore.new
    @collector = SystemMetrics::Collector.new(@store)
  end

  it 'should collect events while collecting' do
    @collector.collect do
      @collector.collect_event(Object.new)
      @collector.collect_event(Object.new)
    end

    @store.should have(2).events
  end

  it 'should not collect events if collecting is turned off' do
    @collector.collect do
      @collector.collect_event(Object.new)
      SystemMetrics.collection_off
      @collector.collect_event(Object.new)
      SystemMetrics.collection_on
    end

    @store.should have(1).events
  end

  it 'should clear out all thread resident events after collecting' do
    @collector.collect do
      @collector.collect_event(Object.new)
      @collector.collect_event(Object.new)
    end

    @store.should have(2).events
    @collector.send(:events).should be_empty
  end

  it 'should set collecting to off after a call to collect' do
    @collector.collect do
      @collector.collect_event(Object.new)
      @collector.collect_event(Object.new)
    end

    SystemMetrics.should_not be_collecting
  end

  it 'should not save events to the store if an exception occurs' do
    lambda {
      @collector.collect do
        @collector.collect_event(Object.new)
        @collector.collect_event(Object.new)
        raise StandardError.new
      end
    }.should raise_error

    @store.should have(0).events
  end
end
