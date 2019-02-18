module StarEthernet
  module StatusItem
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
      status_items = []

      status_data = status_raw_data.unpack('H*').first

      byte1 = status_data[0..1].hex # todo status byte
      byte2 = status_data[2..3].hex # todo version status

      byte3 = status_data[4..5].hex
      status_items.push(PrinterStatus::OfflineBySwitchInput)   if byte3 & 0b01000000 > 0
      status_items.push(PrinterStatus::CoverOpen)              if byte3 & 0b00100000 > 0
      status_items.push(PrinterStatus::Offline)                if byte3 & 0b00001000 > 0
      status_items.push(PrinterStatus::ConversionSwitchClosed) if byte3 & 0b00000100 > 0
      status_items.push(PrinterStatus::EtbCommandExecuted)     if byte3 & 0b00000010 > 0

      byte4 = status_data[6..7].hex
      status_items.push(ErrorStatus::StoppedByHighHeadTemperature) if byte4 & 0b01000000 > 0
      status_items.push(ErrorStatus::NonRecoverableError)          if byte4 & 0b00100000 > 0
      status_items.push(ErrorStatus::AutoCutterError)              if byte4 & 0b00001000 > 0
      status_items.push(ErrorStatus::MechanicalError)              if byte4 & 0b00000100 > 0

      byte5 = status_data[8..9].hex
      status_items.push(ErrorStatus::ReceiveBufferOverflow) if byte5 & 0b01000000 > 0
      status_items.push(ErrorStatus::CommandError)          if byte5 & 0b00100000 > 0
      status_items.push(ErrorStatus::BmError)               if byte5 & 0b00001000 > 0
      status_items.push(ErrorStatus::PresenterPageJamError) if byte5 & 0b00000100 > 0
      status_items.push(ErrorStatus::HeadUpError)           if byte5 & 0b00000010 > 0

      byte6 = status_data[10..11].hex
      status_items.push(SensorStatus::PaperEnd)            if byte6 & 0b00001000 > 0
      status_items.push(SensorStatus::PaperNearInsideEnd)  if byte6 & 0b00000100 > 0
      status_items.push(SensorStatus::PaperNearOutsideEnd) if byte6 & 0b00000010 > 0

      byte7 = status_data[12..13].hex # todo
      byte8 = status_data[14..15].hex # todo
      byte9 = status_data[16..17].hex # todo

      status_items
    end
  end
end
