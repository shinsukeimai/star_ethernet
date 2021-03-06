RSpec.describe StarEthernet::StatusItem do
  describe '#message' do
    context 'without any statuses' do
      it 'returns normal status message' do
        status_item = StarEthernet::StatusItem.decode_status([0x23, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack('C*'))

        expect(status_item.message).to include('Normal status')
      end
    end

    context 'with specific statues' do
      it 'returns some statuses message' do
        status_item = StarEthernet::StatusItem.decode_status([0x23, 0x86, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack('C*'))

        expect(status_item.message).to include('StarEthernet::StatusItem::PrinterStatus::Offline')
      end
    end
  end

  describe '#offline' do
    context 'when printer is online' do
      it 'returns false' do
        status_item = StarEthernet::StatusItem.decode_status([0x23, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack('C*'))

        expect(status_item.offline?).to eq(false)
      end
    end

    context 'when printer is offline' do
      it 'returns true' do
        status_item = StarEthernet::StatusItem.decode_status([0x23, 0x86, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack('C*'))

        expect(status_item.offline?).to eq(true)
      end
    end
  end

  describe '#message' do
    it 'returns statuses message' do
      status_item = StarEthernet::StatusItem.decode_status([0x23, 0x86, 0x02, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00].pack('C*'))
      status_item.purpose = 'purpose'

      expect(status_item.message).to include('EtbCommandExecuted')
      expect(status_item.message).to include('etb:1')
      expect(status_item.message).to include('purpose')
    end
  end

  describe '#unhealty_status?' do
    context 'when printer has some errors' do
      let(:status_item) { StarEthernet::StatusItem.new(statuses: [StarEthernet::StatusItem::PrinterStatus::Offline]) }

      it 'return true' do
        expect(status_item.unhealthy?).to eq(true)
      end
    end

    context 'when printer has no error' do
      let(:status_item) { StarEthernet::StatusItem.new(statuses: [StarEthernet::StatusItem::PrinterStatus::EtbCommandExecuted]) }

      it 'return false' do
        expect(status_item.unhealthy?).to eq(false)
      end
    end
  end

  describe '#need_to_change_paper?' do
    context 'when printer has any sensor statuses' do
      let(:status_item) { StarEthernet::StatusItem.new(statuses: [StarEthernet::StatusItem::SensorStatus::PaperEnd]) }

      it 'returns true' do
        expect(status_item.need_to_change_paper?).to eq(true)
      end
    end

    context 'when printer has no sensor status' do
      let(:status_item) { StarEthernet::StatusItem.new }

      it 'returns false' do
        expect(status_item.need_to_change_paper?).to eq(false)
      end
    end
  end

  describe '.decode_status' do
    context 'when etb is set' do
      it 'returns status_item which etb is set' do
        status_item = StarEthernet::StatusItem.decode_status([0x23, 0x86, 0x02, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00].pack('C*'))

        expect(status_item.etb).to eq(1)
      end
    end
  end
end
