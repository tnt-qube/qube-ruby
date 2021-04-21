module Qube
  class Tube
    attr_reader :name

    def initialize(options = {})
      @config  = Qube.config
      @client  = Client.new
      @name    = options.delete(:name)
      @type    = options.delete(:type)
      @options = options.merge!(if_not_exists: true)
      fetch_or_create_tube
    end

    # POST tubes/:name
    def put(task, options = {})
      response = @client.post("tubes/#{@name}", tube: @name, task: task, options: options)
      response.code == 200
    end

    # GET tubes/:name
    def take(timeout = 0)
      @client.get("tubes/#{@name}", timeout: timeout)&.body
    end

    # PUT tubes/:name/:task_id/ask
    def ack(data)
      task_id  = data.is_a?(Hash) ? data.dig('task_id') : data
      response = @client.put("tubes/#{@name}/#{task_id}/ack", tube: @name, task_id: task_id)
      response.code == 200
    end

    # DELETE tubes/:name
    def drop
      response = @client.delete("tubes/#{@name}")
      response.code == 200
    end

    def each_task(timeout = 0)
      loop do
        task = take(timeout)
        if task.nil? || task.empty?
          break
        else
          yield task
          ack(task)
        end
      end
    end

    private

      def fetch_or_create_tube
        response = @client.post('tubes', tube: @name, type: @type, options: @options.compact)
        self if response.code == 200
      end
  end
end