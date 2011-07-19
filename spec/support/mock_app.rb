class MockApp
  attr_accessor :config

  def config
    @config ||= Config.new
  end

  class Config
    def system_metrics
      @system_metrics ||= {}
    end

    def middleware
      @middleware ||= Middleware.new
    end
  end

  class Middleware < Array
    def use(*args)
      self.push args
    end
  end
end
