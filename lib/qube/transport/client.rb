module Qube
  # Just wrapper, need for the future work
  class Client
    def initialize
      @transport = Qube::HTTP.new
    end

    def method_missing(m, *args)
      @transport.send(m, *args)
    end
  end
end