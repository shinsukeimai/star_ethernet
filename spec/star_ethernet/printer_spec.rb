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
        @socket = server.accept
        @socket.puts('NBS Status')
        expect(@socket.read(data.size)).to eq(data)
        @socket.puts('ASB Status')
        expect(@socket.eof?).to eq(true)
      end
    end
  end
end
