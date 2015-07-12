module network.client;

import std.stdio;

import libasync;
import cerealed: Cerealizer, Decerealizer;

import core: PacketManager;


public class Client {
	AsyncTCPConnection m_conn;

	this(AsyncTCPConnection conn)
	{
		this.m_conn = conn;
	}
	void onConnect() {
		writefln("New client connected from [%s]", m_conn.peer.toAddressString());
		onRead();
	}

	// Note: All buffers must be empty when returning from TCPEvent.READ
	void onRead() {
		static ubyte[] bin = new ubyte[4092];
		while (true) {
			uint len = m_conn.recv(bin);

			if (len > 0) {
				auto data = bin[0..len];
				auto res = cast(string)data;
				writeln("Received data: ", res);
				PacketManager.instance.handle(this, data);
			}
			if (len < bin.length)
				break;
		}
	}

	void onWrite() {
		//m_conn.send(cast(ubyte[])"My Reply");
		//writeln("Sent: My Reply");
	}

	void onClose() {
		writefln("Client disconnected from [%s]", m_conn.peer.toAddressString());

		if(this.m_conn.isConnected)
			this.m_conn.kill(true);
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
				onClose();
				break;
		}
		return;
	}

	public void send(Cerealizer writer)
	{
		send(writer.bytes);
	}

	private void send(const ubyte[] data)
	{
		m_conn.send(data);
	}
}