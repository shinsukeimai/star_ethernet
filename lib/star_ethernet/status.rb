require 'star_ethernet/status_item'

module StarEthernet
  class StarEthernet::Status
    def initialize
      @statuses = []
    end

    def current_status
      @statuses.first
    end

    def set_status(status_data)
      current_status = StatusItem.decode_status(status_data)
      @statuses.push(current_status)
    end
  end
end
