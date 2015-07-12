module interfaces.istateobject;

import std.socket;
import vendor;

public interface IStateObject
{
	@property int BufferSize();

	@property int Id();

	@property bool Close();

	@property byte[] Buffer();

	@property int BytesLeft();

	@property Socket Listener();

	@property Decerealizer Data();

	void append(byte[] buffer);

	void reset();
}