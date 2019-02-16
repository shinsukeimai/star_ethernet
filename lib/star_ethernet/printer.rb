require 'socket'

require 'star_ethernet/status'

module StarEthernet
  class Printer
    RAW_SOCKET_PRINT_PORT = 9100
    STATUS_ACQUISITION_PORT = 9101

    attr_reader :status

    def initialize(host)
      @host = host
      @status = StarEthernet::Status.new
    end

    def print(data)
      socket = socket(RAW_SOCKET_PRINT_PORT)
      nbs_status = socket.read(11)
      @status.set_status(nbs_status)
      socket.print(data)
      socket.close_write
      socket.close
    end

    def current_status
      @status.current_status
    end

    def fetch_status
      socket = socket(STATUS_ACQUISITION_PORT)
      cmd = [0x32] + 50.times.map { 0x00 }
      socket.print(cmd.pack('C*'))
      asb_status = socket.read(11)
      @status.set_status(asb_status)
      socket.close
      @status.current_status
    end

    private

    def socket(port)
      TCPSocket.new(@host, port)
    end
  end
end
