module packets.authenticate.testpacket;

import std.conv;

import interfaces.ipacket;
import cerealed: Cerealizer;

class TestPacket : IPacket 
{
	public static const ushort ID = 0x01;
	private static const string NAME = "HelloConnect";
		
	public string message;

	public @property string Name()
	{
		return NAME;
	}

	public @property string Message()
	{
		return this.message;
	}

	public Cerealizer serialize()
	{
		auto enc = Cerealizer();
		enc ~= cast(ushort)ID;
		enc ~= cast(string)this.message;

		return enc;
	}

	public override string toString()
	{
		return "Packet [" ~ to!string(ID) ~ "] " ~ NAME ~ " contain a message : " ~ this.message;
	}
}