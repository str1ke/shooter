class Queue
  @queue   = {}
  @objects = {}

  class << self
    attr_accessor :queue
    attr_accessor :objects

    def init(object)
      @queue[object.id]   ||= []
      @objects[object.id] ||= object
    end

    def process
      @objects.each do |key, object|
        if @queue[object.id].length != 0
          puts @queue[object.id]
          action = @queue[object.id].shift
          object.send("#{action}") if action
        end
      end
    end
  end
end