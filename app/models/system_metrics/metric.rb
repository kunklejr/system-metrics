module SystemMetrics
  class Metric < ActiveRecord::Base
    attr_accessible :name, :payload, :transaction_id, :duration, :action, :category, :children, :exclusive_duration, :started_at, :request_id, :parent_id

    set_table_name 'system_metrics'
    has_many :children, :class_name => self.name, :foreign_key => :parent_id
    belongs_to :parent, :class_name => self.name
    serialize :payload

    def ancestors
      ancestors = []
      metric = self
      while parent = metric.parent
        ancestors << parent
        metric = parent
      end
      ancestors
    end

    # Returns if the current node is the parent of the given node.
    # If this is a new record, we can use started_at values to detect parenting.
    # However, if it was already saved, we lose microseconds information from
    # timestamps and we must rely solely in id and parent_id information.
    def parent_of?(metric)
      if new_record?
        start = (started_at - metric.started_at) * 1000.0
        start <= 0 && (start + duration >= metric.duration)
      else
        self.id == metric.parent_id
      end
    end

    def child_of?(metric)
      metric.parent_of?(self)
    end
  end
end
