class MockApp
  attr_accessor :config

  def config
    @config ||= Config.new
  end

  class Config
    attr_accessor :system_metrics

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
