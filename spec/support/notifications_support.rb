module NotificationsSupport

  def self.included(base)
    base.class_eval do
      after(:each) do
        ActiveSupport::Notifications.notifier.instance_variable_set(:@subscribers, [])
        ActiveSupport::Notifications.notifier.instance_variable_set(:@listeners_for, {})
      end
    end
  end

  def event(options={})
    SystemMetrics::NestedEvent.new(
      options[:name] || 'sql.active_record',
      options[:start] || (Time.now - 5.seconds),
      options[:end] || Time.now,
      options[:transaction_id] || 'tid',
      options[:payload] || {}
    )
  end

end
