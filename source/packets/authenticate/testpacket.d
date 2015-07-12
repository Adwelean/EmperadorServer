module packets.authenticate.testpacket;

private import interfaces.ipacket;
private import vendor;

class TestPacket : IPacket 
{
	ushort packetId;
	string message;

	public Cerealiser serialize()
	{
		auto enc = Cerealiser();
		enc ~= cast(ushort)packetId;
		enc ~= cast(string)message;

		return enc;
	}
}