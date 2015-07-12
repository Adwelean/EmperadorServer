module network.server;

import std.stdio;
import std.socket;
import std.concurrency;
import core.sync.mutex;
import interfaces : IServer, IStateObject;
import vendor;

public alias void delegate(int clientId, IStateObject clientToken) OnClientConnected;
public alias void delegate(int clientId, Decerealizer reader) OnMessageReceivedHandler;
public alias void delegate(int clientId, bool close) OnMessageSubmittedHandler;
public alias void delegate(int clientId) OnClientDisconnected;

public class Server 
{
	private const int DEFAULT_LIMIT = 250;
	private const ushort DEFAULT_PORT = 555;

	private Socket listener;

	private Address ipEndPoint;
	private ushort port;
	private int limit;

	private bool ipV6;

	private IStateObject[int] clients;
	Mutex mutex;

	this()
    {
		this(DEFAULT_LIMIT, DEFAULT_PORT);
    }

	this(int limit)
    {
		this(limit, DEFAULT_PORT);
    }

	this(int limit, ushort port)
	{
		this.mutex = new Mutex();
		this.port = port;
		this.limit = limit;
	}

	public void startListening()
	{
		auto results = getAddressInfo("::1", AddressInfoFlags.NUMERICHOST);

		if(results.length && results[0].family == AddressFamily.INET6)
		{
			this.ipV6 = true;
			this.ipEndPoint = new Internet6Address(port);
		}
		else
		{
			this.ipV6 = false;
			this.ipEndPoint = new InternetAddress(port);
		}

		startListening(this.ipEndPoint, this.limit);
	}

	private void startListening(Address endPoint, int limit)
	{
		try
		{
			if (this.ipV6)
				this.listener = new TcpSocket(AddressFamily.INET6);
			else
				this.listener = new TcpSocket(AddressFamily.INET);

			{
				this.listener.blocking = false;
				this.listener.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);
				this.listener.bind(endPoint);
				this.listener.listen(limit);

				writefln("Server listening on %s:%s", this.ipEndPoint, this.port);

				while(isAlive)
				{
					accept();
				}
			}
		}
		catch (SocketException se)
		{
			throw se;
		}

	}

	private	void accept() {	  	
		try {
			IStateObject state;
			int id;

			synchronized(mutex)
			{
				auto clientSocket = this.listener.accept();

				if(clientSocket !is null && clientSocket.isAlive()) {
					id = this.clients.length > 0 ? this.clients.keys.length + 1 : 1;
				
					state = new StateObject(clientSocket, id);
					//this.clients ~= state; // not working : Error: cannot append type interfaces.istateobject.IStateObject to type IStateObject[int]
					this.clients[this.clients.length] = state;

					// Experimental
					// Start _receive in a new thread.
					auto receiver = spawn(&_receive, thisTid);
					send(receiver, state);

					auto token = receiveOnly!(IStateObject);

					OnMessageReceivedHandler(token.Id, token.Data);

					token.reset();
					//
				}
				else if(clientSocket !is null) {	
					clientSocket.shutdown(SocketShutdown.BOTH);
					clientSocket.close();
					clientSocket.destroy();
				}
			}

			OnClientConnected(id, state);	
		} 
		catch(SocketAcceptException sae) {
			throw sae;
		}  
		catch(Exception e) {
			throw e;
		}
	}

	private void _receive(Tid ownerTid) {
		// Receive a message from the owner thread.
		receive(
			(IStateObject token) {
				for(;;)
				{
					auto received = token.Listener.receive(token.Buffer);

					if(receive > 0)
					{
						token.append(state.Buffer[0.. received]);
						// Send a message back to the owner thread
						send(ownerTid, token);
					}
				}
			}
		);
	}

	public void send(int id, Cerealized writer)
	{
		//TODO: 
	}

	public void stopListening()
	{
		this.listener.shutdown(SocketShutdown.BOTH);
	}

	public void disconnectClient(int id)
	{
		//auto client = this.clients.get(id, -1);
		auto client = this.clients[id];

		if (client is null)
		{
			throw new Exception("Client does not exist.");
		}

		try
		{
			client.Listener.shutdown(SocketShutdown.BOTH);
			client.Listener.close();
			client.Listener.destroy();
		}
		catch (SocketException se)
		{
			throw se;
		}
		finally
		{
			synchronized (this.mutex)
			{
				this.clients.remove(client.Id);

				OnClientDisconnected(client.Id);
			}
		}
	}

	public void dispose()
	{
		foreach (id; this.clients.keys)
		{
			this.disconnectClient(id);
		}


		if (this.listener.isAlive())
		{
			this.listener.shutdown(SocketShutdown.BOTH);
			this.listener.close();
			this.listener.destroy();
		}
		else
			this.listener.destroy();
	}

	public bool isAlive() const nothrow @property {
		if(this.listener is null) return false;
		try {
			return this.listener.isAlive;			
		} 
		catch(Exception e) {
			return false;
		}
	}
}