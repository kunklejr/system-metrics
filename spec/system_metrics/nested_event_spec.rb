require File.dirname(__FILE__) + '/../spec_helper'

describe SystemMetrics::NestedEvent do
  it "should provide a reader for started_at that pulls directly from the event's time property" do
    time = Time.now
    e = event(:start => time)
    e.started_at.should == time
  end

  it "should provide a reader for ended_at that pulls directly from the event's end property" do
    time = Time.now
    e = event(:end => time)
    e.ended_at.should == time
  end

  it 'should contain child events' do
    e = event
    e.children << event()
    e.should have(1).child
  end

  describe '.arrange' do
    it 'should arrange an array of events in a nested structure' do
      parent = event(:start => Time.now - 10.seconds, :end => Time.now)
      child = event(:start => Time.now - 9.seconds, :end => Time.now - 1.seconds)
      grandchild = event(:start => Time.now - 8.seconds, :end => Time.now - 2.seconds)

      root = SystemMetrics::NestedEvent.arrange([grandchild, child, parent])
      root.should have(1).child
      root.children[0].should == child
      root.children[0].should have(1).child
      root.children[0].children[0].should == grandchild
    end
  end

  describe '#parent_of?' do
    it 'should be a parent of another event if its start and end times contain the target event' do
      parent = event(:start => Time.now - 10.seconds, :end => Time.now)
      child = event(:start => Time.now - 6.seconds, :end => Time.now - 3.seconds)
      parent.parent_of?(child).should be_true
    end
  end

  describe '#child_of?' do
    it 'should be a child of another event if its start and end times are within the parent event' do
      parent = event(:start => Time.now - 10.seconds, :end => Time.now)
      child = event(:start => Time.now - 6.seconds, :end => Time.now - 3.seconds)
      child.child_of?(parent).should be_true
    end
  end

  describe '#exclusive_duration' do
    it 'should calculate the time spent within an event minus all the time spent in child events' do
      now = Time.now
      parent = event(:start => now - 10.seconds, :end => now)
      child = event(:start => now - 9.seconds, :end => now - 1.seconds)
      grandchild = event(:start => now - 8.seconds, :end => now - 2.seconds)
      root = SystemMetrics::NestedEvent.arrange([grandchild, child, parent])
      root.exclusive_duration.should be_within(100).of(2000)
    end
  end

  describe '#to_hash' do
    it 'should return a hash with keys for :name, :started_at, :ended_at, :transaction_id, :payload, :duration, and :exclusive_duration' do
      e = event
      hash = event.to_hash
      hash[:name].should == e.name
      hash[:started_at].should be_within(1).of(e.started_at)
      hash[:ended_at].should be_within(1).of(e.ended_at)
      hash[:transaction_id].should == e.transaction_id
      hash[:payload].should == e.payload
      hash[:duration].should be_within(1).of(e.duration)
      hash[:exclusive_duration].should be_within(1).of(e.exclusive_duration)
    end
  end

  private

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
