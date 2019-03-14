require 'socket'
require 'openssl'

require 'net/telnet'

require 'star_ethernet/status'
require 'star_ethernet/exceptions'

module StarEthernet
  class Printer
    attr_reader :status, :host

    def initialize(host)
      @host = host
      @status = StarEthernet::Status.new(self)
    end

    def print(data)
      begin
        socket = socket(StarEthernet.configuration.raw_socket_print_port)

        if StarEthernet.configuration.nsb
          nbs_status = socket.read(StarEthernet.configuration.asb_status_size)
          @status.set_status(nbs_status, 'receive nbs status')
        end

        socket.print(StarEthernet::Command.initialize_print_sequence)

        fetch_status('fetch etb status for checking counting up after initializing print sequence')

        if current_status.offline?
          raise StarEthernet::PrinterOffline.new(@status.full_messages)
        end

        socket.print(StarEthernet::Command.update_asb_etb_status)

        StarEthernet.configuration.retry_counts.times do |index|
          sleep StarEthernet.configuration.fetch_time_interval
          fetch_status('fetch etb status for reserve etb count before printing')

          break if @status.etb_incremented?
          if index == StarEthernet.configuration.retry_counts - 1
            raise StarEthernet::EtbCountUpFailed.new(@status.full_messages)
          end
        end

        socket.print(StarEthernet::Command.start_document)

        socket.print(data)

        socket.print(StarEthernet::Command.update_asb_etb_status)

        socket.print(StarEthernet::Command.end_document)

        StarEthernet.configuration.retry_counts.times do |index|
          sleep StarEthernet.configuration.fetch_time_interval
          fetch_status('fetch etb status for checking print success')

          break if @status.etb_incremented?
          if index == StarEthernet.configuration.retry_counts - 1
            raise StarEthernet::PrintFailed.new(@status.full_messages)
          end
        end
      ensure
        socket.close
      end
    end

    def send_command(data)
      socket = socket(StarEthernet.configuration.raw_socket_print_port)
      if StarEthernet.configuration.nsb
        nbs_status = socket.read(StarEthernet.configuration.asb_status_size)
        @status.set_status(nbs_status)
      end
      socket.print(data)
      socket.close
    end

    def fetch_status(purpose = '')
      socket = socket(StarEthernet.configuration.status_acquisition_port)
      socket.print(StarEthernet::Command.status_acquisition)
      asb_status = socket.read(StarEthernet.configuration.asb_status_size)
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
      if StarEthernet::configuration.ssl
        ssl = OpenSSL::SSL::SSLSocket.new(TCPSocket.new(@host, port))
        ssl.hostname = @host
        ssl.connect
        ssl
      else
        TCPSocket.new(@host, port)
      end
    end

    def telnet
      telnet = Net::Telnet.new('Host' => @host, 'Port' => StarEthernet.configuration.telnet_port)
      telnet.waitfor(/(.)*login: /)
      telnet.cmd('String' => 'root', 'Match' => /(.)*Password: /)
      telnet.cmd('String' => 'public', 'Match' => /(.)*Selection: /)
      telnet
    end
  end
end
