class TestLogger
  attr_reader :messages

  def initialize
    @messages = []
  end

  def info(msg)
    messages << msg
  end
end
