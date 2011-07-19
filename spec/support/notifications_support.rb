module NotificationsSupport

  def self.included(base)
    base.class_eval do
      after(:each) do
        ActiveSupport::Notifications.notifier.instance_variable_set(:@subscribers, [])
        ActiveSupport::Notifications.notifier.instance_variable_set(:@listeners_for, {})
      end
    end
  end

end
