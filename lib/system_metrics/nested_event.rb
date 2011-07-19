require 'active_support/notifications'

module SystemMetrics
  class NestedEvent < ActiveSupport::Notifications::Event

    def self.arrange(events, options={})
      events.sort! { |a, b| a.end <=> b.end } unless options[:presort] == false

      while event = events.shift
        if parent = events.find { |n| n.parent_of?(event) }
          parent.children << event
        elsif events.empty?
          root = event
        end
      end

      root
    end

    def exclusive_duration
      @exclusive_duration ||= duration - children.inject(0.0) { |sum, child| sum + child.duration }
    end

    def started_at
      self.time
    end

    def ended_at
      self.end
    end

    def children
      @children ||= []
    end

    def parent_of?(event)
      start = (started_at - event.started_at) * 1000.0
      start <= 0 && (start + duration >= event.duration)
    end

    def child_of?(event)
      event.parent_of?(self)
    end

    def to_hash
      {
        :name => name,
        :started_at => started_at,
        :ended_at => self.ended_at,
        :transaction_id => transaction_id,
        :payload => payload,
        :duration => duration,
        :exclusive_duration => exclusive_duration
      }
    end
  end
end
