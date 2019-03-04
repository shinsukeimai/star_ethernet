require 'socket'

RSpec.describe StarEthernet::Printer do
  let(:host) { '127.0.0.1' }

  describe '#print' do
    let!(:print_server) { TCPServer.open(host, StarEthernet.configuration.raw_socket_print_port) }
    let!(:status_server) { TCPServer.open(host, StarEthernet.configuration.status_acquisition_port) }
    let(:data) { 'print data' }

    after do
      print_server.close
      status_server.close
    end

    context 'with valid condition' do
      before do
        Thread.new do
          StarEthernet::Printer.new(host).print(data)
        end
      end

      it 'completes print sequence' do
        print_socket = print_server.accept

        expect_cmd = StarEthernet::Command.initialize_print_sequence
        initialize_print_sequence_cmd = print_socket.read(expect_cmd.size)
        expect(initialize_print_sequence_cmd).to eq(expect_cmd)

        status_socket = status_server.accept
        expect_cmd = StarEthernet::Command.status_acquisition
        status_acquisition_cmd = status_socket.read(expect_cmd.size)
        expect(status_acquisition_cmd).to eq(expect_cmd)
        status_socket.write([0x23, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack('C*'))
        status_socket.close

        expect_cmd = StarEthernet::Command.update_asb_etb_status
        update_asb_etb_status_cmd = print_socket.read(expect_cmd.size)
        expect(update_asb_etb_status_cmd).to eq(expect_cmd)

        status_socket = status_server.accept
        expect_cmd = StarEthernet::Command.status_acquisition
        status_acquisition_cmd = status_socket.read(expect_cmd.size)
        expect(status_acquisition_cmd).to eq(expect_cmd)
        status_socket.write([0x23, 0x86, 0x02, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00].pack('C*')) # count up ETB
        status_socket.close

        expect_cmd = StarEthernet::Command.start_document
        start_document_cmd = print_socket.read(expect_cmd.size)
        expect(start_document_cmd).to eq(expect_cmd)

        receive_data = print_socket.read(data.size)
        expect(receive_data).to eq(data)

        expect_cmd = StarEthernet::Command.update_asb_etb_status
        update_asb_etb_status_cmd = print_socket.read(expect_cmd.size)
        expect(update_asb_etb_status_cmd).to eq(expect_cmd)

        expect_cmd = StarEthernet::Command.end_document
        end_document_cmd = print_socket.read(expect_cmd.size)
        expect(end_document_cmd).to eq(expect_cmd)

        status_socket = status_server.accept
        expect_cmd = StarEthernet::Command.status_acquisition
        status_acquisition_cmd = status_socket.read(expect_cmd.size)
        expect(status_acquisition_cmd).to eq(expect_cmd)
        status_socket.write([0x23, 0x86, 0x02, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00].pack('C*')) # count up ETB
        status_socket.close

        expect(print_socket.eof?).to eq(true)
      end
    end

    context 'with errors before printing' do
      let(:printer) { StarEthernet::Printer.new(host) }

      before do
        Thread.new do
          print_socket = print_server.accept
          status_socket = status_server.accept

          expect_cmd = StarEthernet::Command.initialize_print_sequence
          print_socket.read(expect_cmd.size)

          expect_cmd = StarEthernet::Command.status_acquisition
          status_socket.read(expect_cmd.size)
          status_socket.write([0x23, 0x86, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack('C*'))
        end
      end

      it 'raises error' do
        expect { printer.print(data) }.to raise_error(StarEthernet::PrinterOffline)
      end
    end

    context 'with errors in printing' do
      let(:printer) { StarEthernet::Printer.new(host) }

      before do
        StarEthernet.configuration.retry_counts = 1

        Thread.new do
          print_socket = print_server.accept

          expect_cmd = StarEthernet::Command.initialize_print_sequence
          print_socket.read(expect_cmd.size)

          status_socket = status_server.accept
          expect_cmd = StarEthernet::Command.status_acquisition
          status_socket.read(expect_cmd.size)
          status_socket.write([0x23, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack('C*'))
          status_socket.close

          expect_cmd = StarEthernet::Command.update_asb_etb_status
          print_socket.read(expect_cmd.size)

          status_socket = status_server.accept
          expect_cmd = StarEthernet::Command.status_acquisition
          status_socket.read(expect_cmd.size)
          status_socket.write([0x23, 0x86, 0x02, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00].pack('C*'))
          status_socket.close

          expect_cmd = StarEthernet::Command.start_document
          print_socket.read(expect_cmd.size)

          print_socket.read(data.size)

          expect_cmd = StarEthernet::Command.update_asb_etb_status
          print_socket.read(expect_cmd.size)

          status_socket = status_server.accept
          expect_cmd = StarEthernet::Command.status_acquisition
          status_socket.read(expect_cmd.size)
          status_socket.write([0x23, 0x86, 0x02, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00].pack('C*'))
        end
      end

      after do
        StarEthernet.configuration.set_default
      end

      it 'raises error' do
        expect { printer.print(data) }.to raise_error(StarEthernet::PrintFailed)
      end
    end
  end

  describe '#send_command' do
    context 'with valid condition' do
      let!(:server) { TCPServer.open(host, StarEthernet.configuration.raw_socket_print_port) }
      let(:data) { 'hello printer' }

      before do
        Thread.new do
          StarEthernet::Printer.new(host).send_command(data)
        end
      end

      after do
        server.close
      end

      it 'accepts data' do
        socket = server.accept
        socket.write([0x23, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack('C*'))

        expect(socket.read(data.size)).to eq(data)
      end
    end
  end

  describe '#status' do
    context 'without any warnings and errors' do
      let!(:server) { TCPServer.open(host, StarEthernet.configuration.status_acquisition_port) }
      let(:printer) { StarEthernet::Printer.new(host) }

      before do
        Thread.new do
          printer.fetch_status('purpose message')
        end
      end

      after do
        server.close
      end

      it 'receive status' do
        socket = server.accept
        expect_cmd = StarEthernet::Command.status_acquisition
        status_acquisition_cmd = socket.read(expect_cmd.size)
        expect(status_acquisition_cmd).to eq(expect_cmd)
        socket.write([0x23, 0x86, 0x02, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00].pack('C*'))
        socket.close
      end
    end
  end
end
