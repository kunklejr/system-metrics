class TestStore
  attr_reader :events

  def initialize
    @events = []
  end

  def save(events)
    @events = events
  end
end
