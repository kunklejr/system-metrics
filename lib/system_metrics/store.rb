module SystemMetrics
  class Store

    def save(events)
      return unless events.present?
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
        SystemMetrics::Metric.create(event.to_hash.merge(merge_params))
      end

  end
end
