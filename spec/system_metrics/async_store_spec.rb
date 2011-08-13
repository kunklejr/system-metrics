require File.dirname(__FILE__) + '/../spec_helper'
require 'system_metrics/metric'

describe SystemMetrics::AsyncStore do
  include NotificationsSupport

  describe '#save' do
    it 'should save an array of events hierarchically' do
      parent = event(:start => Time.now - 10.seconds, :end => Time.now)
      child = event(:start => Time.now - 9.seconds, :end => Time.now - 1.seconds)
      grandchild = event(:start => Time.now - 8.seconds, :end => Time.now - 2.seconds)

      store = SystemMetrics::AsyncStore.new

      lambda {
        store.save([grandchild, child, parent])
        sleep(0.1)
      }.should change(SystemMetrics::Metric, :count).by(3)

      metrics = SystemMetrics::Metric.all
      verify_equal(parent, metrics[0])
      verify_equal(child, metrics[0].children[0])
      verify_equal(grandchild, metrics[0].children[0].children[0])
    end

    it 'should not attempt to save anything if passed an empty array of events' do
      store = SystemMetrics::AsyncStore.new
      lambda { store.save([]); sleep(0.1) }.should_not change(SystemMetrics::Metric, :count)
    end

    it 'should not attempt to save anything if passed a nil' do
      store = SystemMetrics::AsyncStore.new
      lambda { store.save(nil); sleep(0.1) }.should_not change(SystemMetrics::Metric, :count)
    end
  end

  private

    def verify_equal(event, metric)
      event.name.should == metric.name
      event.action.should == metric.action
      event.category.should == metric.category
      event.transaction_id.should == metric.transaction_id
      event.payload.should == metric.payload
      event.started_at.should be_within(1).of(metric.started_at)
      event.duration.should be_within(1).of(metric.duration)
      event.exclusive_duration.should be_within(1).of(metric.exclusive_duration)
    end

end
