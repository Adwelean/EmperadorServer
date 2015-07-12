module core.packetmanager;

import std.stdio;

import cerealed: Decerealizer;

import core.singleton;
import network: Client;
import enumeration.states;
import parsers.authenticatorparser;

public class PacketManager
{
	mixin Singleton!PacketManager;

	private Decerealizer dec;

	this() {}

	public void handle(Client client, const ubyte[] packet)
	{
		dec = Decerealizer(packet);

		ushort packetId = dec.value!ushort;
		States phase = getPhase(packetId);

		switch(phase)
		{
			case States.AUTH:
				AuthenticatorParser.instance.parse(client, packetId, dec);
				break;
			default:
				writeln("Unknown packet");
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