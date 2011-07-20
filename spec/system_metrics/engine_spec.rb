require File.dirname(__FILE__) + '/../spec_helper'

describe SystemMetrics::Engine do
  before(:each) do
    @app = MockApp.new
    @store = TestStore.new
    @app.config.system_metrics = SystemMetrics::Config.new
    @app.config.system_metrics.instruments << SystemMetrics::Instrument::Base.new(/xyz123/)
    @app.config.system_metrics.store = @store
    @engine = SystemMetrics::Engine.new
    run_initializers(@engine)
  end

  it 'should initialize the SystemMetrics configuration' do
    @engine.smc.should_not be_nil
    @engine.smc.should be_valid
    @engine.collector.should_not be_nil
  end

  it 'should setup the SystemMetrics::Middleware' do
    middleware = @app.config.middleware.first
    middleware[0].should == SystemMetrics::Middleware
    middleware[1].should_not be_nil
    middleware[2].should_not be_nil
  end

  describe '#process_event' do
    it 'should collect events that do not have an instrument that handles them' do
      event = ActiveSupport::Notifications::Event.new('unknown', Time.now - 5, Time.now, 'tid', {})
      @engine.collector.collect { @engine.send(:process_event, event) }
      @store.events.should include(event)
    end

    it 'should collect events that have an instrument that handles and does not ignore them' do
      event = ActiveSupport::Notifications::Event.new('xyz123', Time.now - 5, Time.now, 'tid', {})
      @engine.collector.collect { @engine.send(:process_event, event) }
      @store.events.should include(event)
    end

    it 'should not collect events whose instrument indicates that it should be ignored' do
      class IgnoringInstrument
        def handles?(event)
          true
        end

        def ignore?(event)
          true
        end
      end

      @app.config.system_metrics.instruments << IgnoringInstrument.new
      engine = SystemMetrics::Engine.new
      run_initializers(engine)
      event = ActiveSupport::Notifications::Event.new('abc123', Time.now - 5, Time.now, 'tid', {})
      engine.collector.collect { @engine.send(:process_event, event) }
      @store.events.should_not include(event)
    end
  end

  private

    def run_initializer(engine, name)
      initializer = engine.initializers.find do |initializer|
        initializer.name == name
      end
      initializer.run @app
    end

    def run_initializers(engine)
      ['system_metrics.initialize', 'system_metrics.start_subscriber', 'system_metrics.add_middleware'].each do |name|
        run_initializer(engine, name)
      end
    end

end
