module network.server;
import libasync;
import std.stdio;

import network.client;

public class Server {
	AsyncTCPListener m_listener;

	this(string host, size_t port, EventLoop evl) {
		m_listener = new AsyncTCPListener(evl);
		if (m_listener.host(host, port).run(&handler))
			writeln("Listening to ", m_listener.local.toString());

	}

	void delegate(TCPEvent) handler(AsyncTCPConnection conn) {
		auto tcpConn = new Client(conn);
		return &tcpConn.handler;
	}

}