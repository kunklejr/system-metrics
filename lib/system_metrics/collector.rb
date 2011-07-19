module SystemMetrics
  class Collector
    attr_reader :store

    def initialize(store)
      @store = store
    end

    def collect_event(event)
      events.push event if SystemMetrics.collecting?
    end

    def collect
      events.clear
      SystemMetrics.collection_on
      result = yield
      SystemMetrics.collection_off
      store.save events.dup
      result
    ensure
      SystemMetrics.collection_off
      events.clear
    end

    private

      def events
        Thread.current[:system_metrics_events] ||= []
      end

  end
end
