require File.dirname(__FILE__) + '/../spec_helper'
require 'system_metrics/engine'

describe SystemMetrics::Engine do
  before(:each) do
    @app = MockApp.new
    @store = TestStore.new
    @app.config.system_metrics[:instruments] = [Comb::Instrument::Base.new(/xyz123/)]
    @app.config.system_metrics[:store] = @store
  end

  it 'should establish ActiveSupport::Notification subscribers for each instrument' do
    @app.config.system_metrics[:instruments] = [Comb::Instrument::Base.new(/^sql/), Comb::Instrument::Base.new(/^render/)]
    engine = SystemMetrics::Engine.new
    run_initializers(engine)

    collector = SystemMetrics::Collector.new(@store)
    collector.collect do
      ActiveSupport::Notifications.instrument 'sql.active_record'
      ActiveSupport::Notifications.instrument 'render.action_view'
      ActiveSupport::Notifications.instrument 'process.action_controller'
    end

    @store.should have(2).events
    @store.events.map(&:name) =~ ['sql.active_record', 'render.action_view']
  end

  it 'should setup the SystemMetrics::Middleware' do
    engine = SystemMetrics::Engine.new
    run_initializers(engine)

    middleware = @app.config.middleware.first
    middleware[0].should == SystemMetrics::Middleware
    middleware[1].should_not be_nil
    middleware[2].should_not be_nil
  end

  def run_initializer(engine, name)
    initializer = engine.initializers.find do |initializer|
      initializer.name == name
    end
    initializer.run @app
  end

  def run_initializers(engine)
    ['system_metrics.initialize', 'system_metrics.add_subscribers', 'system_metrics.add_middleware'].each do |name|
      run_initializer(engine, name)
    end
  end
end
