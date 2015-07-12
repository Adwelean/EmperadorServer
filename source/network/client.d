module network.client;

import std.stdio;
import libasync;
import cerealed: Decerealizer;

public class Client {
	AsyncTCPConnection m_conn;

	this(AsyncTCPConnection conn)
	{
		this.m_conn = conn;
	}
	void onConnect() {
		onRead();
		//onWrite();
	}

	// Note: All buffers must be empty when returning from TCPEvent.READ
	void onRead() {
		static ubyte[] bin = new ubyte[4092];
		while (true) {
			uint len = m_conn.recv(bin);

			if (len > 0) {
				writeln(len);
				auto dec = new Decerealizer(bin[0..len]);
				//dec.reset();
				auto val = dec.value!ushort;
				auto res = cast(string)bin[0..len];
				writeln("Received data: ", res);
				if(val == 0x01)
					writeln("good");
				else
					writeln("bad");
				
				
			}
			if (len < bin.length)
				break;
		}
	}

	void onWrite() {
		m_conn.send(cast(ubyte[])"My Reply");
		writeln("Sent: My Reply");
	}

	void onClose() {
		writeln("Connection closed");
	}

	void handler(TCPEvent ev) {
		final switch (ev) {
			case TCPEvent.CONNECT:
				onConnect();
				break;
			case TCPEvent.READ:
				onRead();
				break;
			case TCPEvent.WRITE:
				onWrite();
				break;
			case TCPEvent.CLOSE:
				onClose();
				break;
			case TCPEvent.ERROR:
				//assert(false, "Error during TCP Event");
				
				break;
		}
		return;
	}

}