module packets.authenticate.helloconnect;

private import interfaces.ipacket;
private import vendor;

public class HelloConnect : IPacket
{
	public static const ushort ID = 0x01;
	private static const string NAME = "HelloConnect";

	public @property string Name()
	{
		return NAME;
	}

	public Cerealizer serialize()
	{
		auto enc = Cerealizer();
		enc ~= cast(ushort)ID;

		return enc;
	}

	public override string toString()
	{
		return "Packet [" ~ ID ~ "] " ~ NAME;
	}
}