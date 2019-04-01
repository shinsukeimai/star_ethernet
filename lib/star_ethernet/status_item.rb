module StarEthernet
  class StatusItem
    attr_reader :statuses, :time
    attr_writer :purpose
    attr_accessor :etb

    def initialize(statuses: [])
      @statuses = statuses
      @etb = nil
      @time = Time.now
      @purpose = nil
    end

    def offline?
      @statuses.include?(PrinterStatus::Offline)
    end

    def append_status(status)
      @statuses.push(status)
    end

    def unhealthy?
      @statuses.reject{ |s| s.== PrinterStatus::EtbCommandExecuted}.any?
    end

    def message
      msg = @statuses.empty? ?
        "[#{@time.to_s}] Normal status" :
        "[#{@time.to_s}] #{@statuses.map{ |status| status.to_s }.join(', ')}"
      msg += " etb:#{@etb}"
      msg += " (#{@purpose})" if @purpose
      msg
    end


    class HeaderStatus
      # todo
    end

    class PrinterStatus
      class OfflineBySwitchInput; end
      class CoverOpen; end
      class Offline; end
      class ConversionSwitchClosed; end
      class EtbCommandExecuted; end
    end

    class ErrorStatus
      class StoppedByHighHeadTemperature; end
      class NonRecoverableError; end
      class AutoCutterError; end
      class MechanicalError; end # except TUP500
      class ReceiveBufferOverflow; end
      class CommandError; end
      class BmError; end
      class PresenterPageJamError; end
      class HeadUpError; end # except TUP500
    end

    class SensorStatus
      class PaperEnd; end
      class PaperNearInsideEnd; end
      class PaperNearOutsideEnd; end
    end

    class PresenterStatus
      class StateWhereIsNoPaperInPresenter; end
      class StateWherePaperIsSupplied; end
      class StatWherePaperIsDischarged; end
      class StateWherePaperIsRecovered; end
      class StateWherePaperIsPulledOut; end
    end

    def self.decode_status(status_raw_data)
      status_item = StatusItem.new

      status_data = status_raw_data.unpack('H*').first

      byte1 = status_data[0..1].hex # todo status byte
      byte2 = status_data[2..3].hex # todo version status

      byte3 = status_data[4..5].hex
      status_item.append_status(PrinterStatus::OfflineBySwitchInput)   if byte3 & 0b01000000 > 0
      status_item.append_status(PrinterStatus::CoverOpen)              if byte3 & 0b00100000 > 0
      status_item.append_status(PrinterStatus::Offline)                if byte3 & 0b00001000 > 0
      status_item.append_status(PrinterStatus::ConversionSwitchClosed) if byte3 & 0b00000100 > 0
      status_item.append_status(PrinterStatus::EtbCommandExecuted)     if byte3 & 0b00000010 > 0

      byte4 = status_data[6..7].hex
      status_item.append_status(ErrorStatus::StoppedByHighHeadTemperature) if byte4 & 0b01000000 > 0
      status_item.append_status(ErrorStatus::NonRecoverableError)          if byte4 & 0b00100000 > 0
      status_item.append_status(ErrorStatus::AutoCutterError)              if byte4 & 0b00001000 > 0
      status_item.append_status(ErrorStatus::MechanicalError)              if byte4 & 0b00000100 > 0

      byte5 = status_data[8..9].hex
      status_item.append_status(ErrorStatus::ReceiveBufferOverflow) if byte5 & 0b01000000 > 0
      status_item.append_status(ErrorStatus::CommandError)          if byte5 & 0b00100000 > 0
      status_item.append_status(ErrorStatus::BmError)               if byte5 & 0b00001000 > 0
      status_item.append_status(ErrorStatus::PresenterPageJamError) if byte5 & 0b00000100 > 0
      status_item.append_status(ErrorStatus::HeadUpError)           if byte5 & 0b00000010 > 0

      byte6 = status_data[10..11].hex
      status_item.append_status(SensorStatus::PaperEnd)            if byte6 & 0b00001000 > 0
      status_item.append_status(SensorStatus::PaperNearInsideEnd)  if byte6 & 0b00000100 > 0
      status_item.append_status(SensorStatus::PaperNearOutsideEnd) if byte6 & 0b00000010 > 0

      byte7 = status_data[12..13].hex # todo

      byte8 = status_data[14..15].hex
      status_item.etb = ((byte8 >> 1) & 0b00000111) + ((byte8 >> 2) & 0b00011000)

      byte9 = status_data[16..17].hex # todo

      status_item
    end
  end
end
