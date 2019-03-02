require 'socket'
require 'net/telnet'

require 'star_ethernet/status'
require 'star_ethernet/exceptions'

module StarEthernet
  class Printer
    RAW_SOCKET_PRINT_PORT = 9100
    STATUS_ACQUISITION_PORT = 9101
    ASB_STATUS_SIZE = 9
    FETCH_TIME_INTERVAL = 0.1
    RETRY_COUNTS = 300

    attr_reader :status, :host

    def initialize(host, nsb: false, asb: false, interval: FETCH_TIME_INTERVAL, retry_counts: RETRY_COUNTS)
      @host, @nsb, @asb, @interval, @retry_counts = host, nsb, asb, interval, retry_counts
      @status = StarEthernet::Status.new(self)
    end

    def print(data)
      begin
        socket = socket(RAW_SOCKET_PRINT_PORT)

        if @nsb
          nbs_status = socket.read(ASB_STATUS_SIZE)
          @status.set_status(nbs_status, 'receive nbs status')
        end

        socket.print(StarEthernet::Command.initialize_print_sequence)

        fetch_status('fetch etb status for checking counting up after initializing print sequence')

        if current_status.offline?
          raise StarEthernet::PrinterOffline.new(@status.full_messages)
        end

        socket.print(StarEthernet::Command.update_asb_etb_status)

        @retry_counts.times do |index|
          sleep @interval
          fetch_status('fetch etb status for reserve etb count before printing')

          break if @status.etb_incremented?
          if index == @retry_counts - 1
            raise StarEthernet::EtbCountUpFailed.new(@status.full_messages)
          end
        end

        socket.print(StarEthernet::Command.start_document)

        socket.print(data)

        socket.print(StarEthernet::Command.update_asb_etb_status)

        socket.print(StarEthernet::Command.end_document)

        @retry_counts.times do |index|
          sleep @interval
          fetch_status('fetch etb status for checking print success')

          break if @status.etb_incremented?
          if index == @retry_counts - 1
            raise StarEthernet::PrintFailed.new(@status.full_messages)
          end
        end
      ensure
        socket.close
      end
    end

    def send_command(data)
      socket = socket(RAW_SOCKET_PRINT_PORT)
      if @nsb
        nbs_status = socket.read(ASB_STATUS_SIZE)
        @status.set_status(nbs_status)
      end
      socket.print(data)
      socket.close
    end

    def fetch_status(purpose = '')
      socket = socket(STATUS_ACQUISITION_PORT)
      socket.print(StarEthernet::Command.status_acquisition)
      asb_status = socket.read(ASB_STATUS_SIZE)
      @status.set_status(asb_status, purpose)
      socket.close
      @status.current_status
    end

    def reboot
      telnet.cmd('String' => '98', 'Match' => /(.)*Selection: /)
      telnet.cmd('String' => '2', 'Match' => /(.)*Selection: /)
    end

    def current_status
      @status.current_status
    end

    def socket(port)
      TCPSocket.new(@host, port)
    end

    def telnet
      telnet = Net::Telnet.new('Host' => @host)
      telnet.waitfor(/(.)*login: /)
      telnet.cmd('String' => 'root', 'Match' => /(.)*Password: /)
      telnet.cmd('String' => 'public', 'Match' => /(.)*Selection: /)
      telnet
    end
  end
end
