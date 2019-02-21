require 'star_ethernet/status_item'

module StarEthernet
  class StarEthernet::Status
    def initialize
      @statuses = []
    end

    def all_statuses
      @statuses
    end

    def current_status
      @statuses.last
    end

    def previous_status
      @statuses[-2]
    end

    def set_status(status_data)
      current_status = StatusItem.decode_status(status_data)
      @statuses.push(current_status)
    end
  end
end
