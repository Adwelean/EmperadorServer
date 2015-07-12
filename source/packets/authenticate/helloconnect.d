module packets.authenticate.helloconnect;

private import interfaces.ipacket;
private import vendor;

public class HelloConnect : IPacket
{
	ushort packetId;

	public Cerealiser serialize()
	{
		auto enc = Cerealiser();
		enc ~= cast(ushort)packetId;

		return enc;
	}
}