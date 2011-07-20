require File.dirname(__FILE__) + '/../spec_helper'

describe SystemMetrics::Middleware do
  before(:each) do
    @store = TestStore.new
    @collector = SystemMetrics::Collector.new(@store)
  end

  it 'should invoke the collector for a non-excluded paths' do
    event = Object.new
    blk = Proc.new { @collector.collect_event(event) }
    middleware = SystemMetrics::Middleware.new(blk, @collector, [])
    env = { "PATH_INFO" => '/collect' }

    middleware.call(env)
    @store.should have(1).events
  end

  it 'should not invoke the collector for excluded paths' do
    event = Object.new
    blk = Proc.new { @collector.collect_event(event) }
    middleware = SystemMetrics::Middleware.new(blk, @collector, [/^\/collect/])
    env = { "PATH_INFO" => '/collect' }

    middleware.call(env)
    @store.should have(0).events
  end

  it 'should wrap everything with an instrumentation for rack requests' do
    ActiveSupport::Notifications.subscribe(/\.rack$/) do |*args|
      @collector.collect_event(ActiveSupport::Notifications::Event.new(*args))
    end

    event = Object.new
    blk = Proc.new {}
    middleware = SystemMetrics::Middleware.new(blk, @collector, [])
    env = { "PATH_INFO" => '/collect' }

    middleware.call(env)
    @store.should have(1).events
    @store.events.first.name.should == 'request.rack'
  end
end
