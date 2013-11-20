require 'socket'
include Socket::Constants

class Tt
  class << self
    attr_accessor :client, :server

    def connect(address, port, mode = :server)
      #puts address
      #puts port      
      if mode == :server
        Thread.new do
          self.server = Socket.new(AF_INET, SOCK_STREAM)
          sockaddr    = Socket.pack_sockaddr_in(port, '0.0.0.0')

          server.bind(sockaddr)
          server.listen(1)

          client, addr_info = self.server.accept
          
          while action = client.gets.chomp.strip
            # Queue.queue['p2'] << "go_#{action}"
            Queue.queue['p2'] << action
          end
        end
      else
        address = 'localhost'
        self.client = TCPSocket.new address, port
      end
    end

    def send(msg)
      # msg = msg.gsub(/go_/, '')
      # msg += ' ' while msg.length < 5

      client.puts(msg)
    end

  end
end