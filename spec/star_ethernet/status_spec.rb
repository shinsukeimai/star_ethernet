RSpec.describe StarEthernet::Status do
  let(:host) { '127.0.0.1' }

  let(:printer) { StarEthernet::Printer.new(host) }
  let(:status) { StarEthernet::Status.new(printer) }

  describe '#etb_increments?' do
    context 'when there is no status_item' do
      it 'returns false' do
        expect(status.etb_incremented?).to eq(false)
      end
    end

    context 'when there etb is not changed' do
      before do
        status.set_status([0x23, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack('C*'))
        status.set_status([0x23, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack('C*'))
      end

      it 'returns false' do
        expect(status.etb_incremented?).to eq(false)
      end
    end

    context 'when etb is incremented' do
      before do
        status.set_status([0x23, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack('C*'))
        status.set_status([0x23, 0x86, 0x02, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00].pack('C*'))
      end

      it 'returns true' do
        expect(status.etb_incremented?).to eq(true)
      end
    end

    context 'when etb is over 31 and incremented' do
      before do
        status.set_status([0x23, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x6e, 0x00].pack('C*'))
        status.set_status([0x23, 0x86, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack('C*'))
      end

      it 'returns true' do
        expect(status.etb_incremented?).to eq(true)
      end
    end
  end
end
