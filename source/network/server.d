module network.server;
import libasync;
import std.stdio;

import network.client;
import vendor;

public class Server {
	AsyncTCPListener m_listener;

	private Client[int] clients;

	this(string host, size_t port, EventLoop evl) {
		m_listener = new AsyncTCPListener(evl);
		if (m_listener.host(host, port).run(&handler))
			writeln("Listening to ", m_listener.local.toString());

	}

	void delegate(TCPEvent) handler(AsyncTCPConnection conn) {
		auto tcpConn = new Client(conn);
		this.clients[this.clients.length] = tcpConn;
		return &tcpConn.handler;
	}

	public void send(int clientId, string msg)
	{
		auto enc = Cerealizer();
		enc ~= cast(string)msg;

		send(clientId, enc);
	}

	public void send(int clientId, Cerealizer writer)
	{
		auto client = this.clients.get(clientId, null);

		if(client !is null)
			send(client, writer);
	}

	public void send(Client client, Cerealizer writer)
	{
		client.send(writer);
	}

	public void sendBroadcast(Cerealizer writer)
	{
		foreach(client; this.clients)
		{
			client.send(writer);
		}
	}
}