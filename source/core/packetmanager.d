module core.packetmanager;

import std.stdio;

private import core.singleton;
private import vendor;
private import enumeration.states;
private import parsers.authenticatorparser;

public class PacketManager
{
	mixin Singleton!PacketManager;

	private Decerealizer dec;

	this() {}

	public void handle(const ubyte[] packet)
	{
		dec = Decerealizer(packet);

		ushort packetId = dec.value!ushort;
		States phase = getPhase(packetId);

		// make sure to start at beginning
		dec.reset();

		switch(phase)
		{
			case States.AUTH:
				AuthenticatorParser.instance.parse(packetId, dec);
				break;
			default:
				break;
		}
	}

	public States getPhase(ushort packetId)
	{
		if(packetId < 0x20)
			return States.AUTH;
		else if(packetId < 0x40)
			return States.UPDATER;
		else if(packetId < 0x60)
			return States.SERVER;
		else
			return States.UNKNOWN;
	}
}