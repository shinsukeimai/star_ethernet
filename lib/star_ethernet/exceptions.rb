module StarEthernet
  class PrinterError < StandardError
    def initialize(statuses_message)
      super(statuses_message)
    end
  end

  class EtbCountUpFailed < PrinterError; end

  class PrintFailed < EtbCountUpFailed; end

  class PrinterOffline < PrinterError; end
end
