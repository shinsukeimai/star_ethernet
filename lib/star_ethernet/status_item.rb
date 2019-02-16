module StarEthernet
  module StatusItem
    class BasicStatus
      # todo
    end

    class ErrorStatus
      # todo
    end

    class SensorStatus
      # todo
    end

    class EtbCounterStatus
      # todo
    end

    class PresentorStatus
      # todo
    end

    class NormalStatus < BasicStatus; end

    def self.decode_status(status_raw_data)
      status_data = status_raw_data.unpack('h*').first
      if status_data == '3268000000000000000000'
        StarEthernet::StatusItem::NormalStatus
      else
        StarEthernet::StatusItem::ErrorStatus
      end
    end
  end
end
