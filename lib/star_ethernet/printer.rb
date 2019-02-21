require 'socket'

require 'star_ethernet/status'

module StarEthernet
  class Printer
    RAW_SOCKET_PRINT_PORT = 9100
    STATUS_ACQUISITION_PORT = 9101
    ASB_STATUS_SIZE = 9
    FETCH_TIME_INTERVAL = 0.1
    RETRY_COUNTS = 300

    module PrintError
      class EtbCountUpFailed < StandardError; end
      class PrintFailed < EtbCountUpFailed; end
    end

    attr_reader :status

    def initialize(host, nsb: false, asb: false, interval: FETCH_TIME_INTERVAL, retry_counts: RETRY_COUNTS)
      @host = host
      @status = StarEthernet::Status.new
      @nsb = nsb
      @asb = asb
      @interval = interval
      @retry_counts = retry_counts
    end

    def print(data)
      begin
        socket = socket(RAW_SOCKET_PRINT_PORT)

        if @nsb
          nbs_status = socket.read(ASB_STATUS_SIZE)
          @status.set_status(nbs_status)
        end

        socket.print(StarEthernet::Command.initialize_print_sequence)

        fetch_status

        socket.print(StarEthernet::Command.update_asb_etb_status)

        @retry_counts.times do |index|
          sleep @interval
          fetch_status

          break if etb_incremented?
          if index == @retry_counts - 1
            raise PrintError::EtbCountUpFailed
          end
        end

        socket.print(StarEthernet::Command.start_document)

        socket.print(data)

        socket.print(StarEthernet::Command.update_asb_etb_status)

        socket.print(StarEthernet::Command.end_document)

        @retry_counts.times do |index|
          sleep @interval
          fetch_status
          break if etb_incremented?
          if index == @retry_counts - 1
            raise PrintError::PrintFailed
          end
        end
      rescue PrintError

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

    def fetch_status
      socket = socket(STATUS_ACQUISITION_PORT)
      socket.print(StarEthernet::Command.status_acquisition)
      asb_status = socket.read(ASB_STATUS_SIZE)
      @status.set_status(asb_status)
      socket.close
      @status.current_status
    end

    def etb_incremented?
      current_etb == previous_etb + 1
    end

    def current_etb
      current_status.etb
    end

    def previous_etb
      previous_status.etb
    end

    def current_status
      @status.current_status
    end

    def previous_status
      @status.previous_status
    end

    def socket(port)
      TCPSocket.new(@host, port)
    end
  end
end
