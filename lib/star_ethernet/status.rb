require 'star_ethernet/status_item'

module StarEthernet
  class StarEthernet::Status
    attr_reader :status_items

    def initialize(printer)
      @printer = printer
      @status_items = []
    end

    def current_status
      @status_items.last
    end

    def previous_status
      @status_items[-2]
    end

    def set_status(status_data, purpose = '')
      current_status = StatusItem.decode_status(status_data)
      current_status.purpose = purpose
      @status_items.push(current_status)
    end

    def full_messages
      <<~"EOS"
      #{@printer.host} printer's statuses are
      #{@status_items.map{ |status_item| status_item.message }.join("\n")}
      EOS
    end
  end
end
