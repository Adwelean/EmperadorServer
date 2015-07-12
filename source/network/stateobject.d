/*module network.stateobject;

import std.socket;
import interfaces: IStateObject;
import vendor;

public class StateObject : IStateObject
{
	/* Contains the state information. *

	private const int BUFFER_SIZE = 1024;

	private Decerealizer reader;
	private int bytesLeft = 0;

	private byte[] buffer = new byte[BUFFER_SIZE];
	private Socket listener;
	private int id;
	private bool close;


	this(Socket listener, int id = -1)
	{
		this.listener = listener;
		this.id = id;
		this.close = false;

		this.reader = Decerealizer(buffer);
		this.reset();
	}

	public @property int Id()
	{
		return this.id;
	}

	public @property bool Close()
	{ 
		return this.close;
	}

	public @property int BufferSize()
	{
		return BUFFER_SIZE;
	}

	public @property byte[] Buffer()
	{
		return this.buffer;
	}

	public @property int BytesLeft()
	{
		return this.bytesLeft;
	}

	public @property Socket Listener()
	{
		return this.listener;
	}

	public @property Decerealizer Data()
	{
		return this.reader;
	}

	public void append(byte[] buffer)
	{
		this.reader = Decerealizer(buffer);
		//this.bytesLeft = this.reader.bytesLeft;
		this.reader.reset; // make sure the position of stream is 0 before use
	}

	public void reset()
	{
		this.reader.reset;
	}
}*/