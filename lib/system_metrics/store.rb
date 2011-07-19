module SystemMetrics
  class Store
    def save(events)
      root_event = SystemMetrics::NestedEvent.arrange(events, :presort => false)
      root_model = create_metric(root_event)
      root_model.update_attributes(:request_id => root_model.id)
      save_tree(root_event.children, root_model.id, root_model.id)
    end

    private

    def save_tree(events, request_id, parent_id)
      events.each do |event|
        model = create_metric(event, :request_id => request_id, :parent_id => parent_id)
        save_tree(event.children, request_id, model.id)
      end
    end

    def create_metric(event, merge_params={})
      action, category = event.name.split('.')
      params = event.to_hash.delete_if do |key, value|
        ![:name, :started_at, :transaction_id, :payload, :duration, :exclusive_duration].include?(key)
      end
      params = params.merge(merge_params).merge(
        :action => action,
        :category => category
      )
      SystemMetrics::Metric.create(params)
    end
  end
end
