module packets.packetbase;

import interfaces.ipacket;
import std.conv;

public abstract class PacketBase : IPacket
{
	private ushort opCode;

	@property ushort OpCode() { return this.opCode; }

	this(ushort opCode)
	{
		this.opCode = opCode;
	}

	public abstract byte[] serialize();
	public abstract bool deserialize(byte[] packet);

	public override string toString()
	{
		return "Packet [" ~ to!string(this.opCode) ~ "]";
	}
}