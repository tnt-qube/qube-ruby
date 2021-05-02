module Qube
  class Queue
    attr_reader :tubes
    attr_reader :statistics

    def initialize
      @config     = Qube.config
      @client     = Client.new
      @tubes      = nil
      @statistics = nil
    end

    def enqueue(tube, task, options = {})
      response = @client.post("tubes/#{tube}", tube: tube, task: task, options: options)
      response.code == 200
    end

    def statistics
      @statistics ||= @client.get('statistics')&.body
    end

    def tubes
      @tubes ||= @client.get('tubes')&.body
    end

    def create_tube(options = {})
      Tube.new(options)
    end

    def tube_exist?(name)
      tubes.include?(name)
    end

    def delete_tube(name)
      @client.delete("tubes/#{name}")&.body
    end

  end
end