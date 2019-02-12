require 'socket'

module StarEthernet
  class Printer
    def initialize(host)
      @host = host
    end

    def print(data)
      socket = TCPSocket.new(@host, RAW_SOCKET_PRINT_PORT)
      nbs_status = socket.gets
      socket.write(data)
      asb_status = socket.gets
      socket.close
    end
  end
end
