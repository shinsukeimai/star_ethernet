require 'socket'

RSpec.describe StarEthernet::Printer do
  HOST = '127.0.0.1'

  describe '#print' do
    context 'with valid condition' do
      let!(:server) { TCPServer.open(HOST, StarEthernet::RAW_SOCKET_PRINT_PORT) }
      let(:data) { 'hello printer' }

      before do
        Thread.new do
          StarEthernet::Printer.new(HOST).print(data)
        end
      end

      after do
        server.close
      end

      it 'accepts data' do
        socket = server.accept
        socket.write([0x23, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack('C*'))

        expect(socket.read(data.size)).to eq(data)

        expect(socket.eof?).to eq(true)
      end
    end
  end

  describe '#status' do
    context 'without any warnings and errors' do
      let!(:server) { TCPServer.open(HOST, StarEthernet::STATUS_ACQUISITION_PORT) }
      let(:printer) { StarEthernet::Printer.new(HOST) }
      let(:status) { 'valid status' }

      before do
        Thread.new do
          printer.fetch_status
        end
      end

      after do
        server.close
      end

      it 'receive status' do
        socket = server.accept
        cmd = socket.read(26)

        expect(cmd.unpack('H*').first).to eq('3200000000000000000000000000000000000000000000000000')

        socket.write([0x23, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack('C*'))

        while printer.current_status != StarEthernet::StatusItem::NormalStatus
          # wait for response
          # p printer.current_status
        end

        expect(printer.current_status).to eq(StarEthernet::StatusItem::NormalStatus)
      end
    end
  end
end
