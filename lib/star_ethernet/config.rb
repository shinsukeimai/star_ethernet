module StarEthernet
  class Config
    attr_accessor :raw_socket_print_port, :status_acquisition_port, :telnet_port,
      :asb_status_size, :fetch_time_interval, :retry_counts, :asb, :nsb

    def initialize
      set_default
    end

    def set_default
      @raw_socket_print_port   = 9100
      @status_acquisition_port = 9101
      @telnet_port             = 23
      @asb_status_size         = 9
      @fetch_time_interval     = 0.1
      @retry_counts            = 300
      @asb                     = false
      @nsb                     = false
    end
  end
end
