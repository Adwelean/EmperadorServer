module packets.packetbase;

private import interfaces.ipacket;

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
}