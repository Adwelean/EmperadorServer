module parsers.authenticatorparser;

private import std.stdio;
private import std.conv;

private import core.singleton;
private import interfaces.ipacket;
private import parsers.parserbase;
private import vendor;

private import packets.authenticate;

public class AuthenticatorParser : ParserBase
{
	mixin Singleton!AuthenticatorParser;

	this() { }

	public override void registerFunction()
	{
		PacketsDictionary[0x01] = &testHC;
		PacketsDictionary[0x02] = &testPacket;
	}

	public override void parse(uint packetID, Decerealizer packet)
	{
		PacketsDictionary[packetID](packet);
	}

	public int testHC(Decerealizer packet)
	{
		auto hc = packet.value!HelloConnect;

		writeln("OK MA GUEULE !");

		return 0;
	}

	public int testPacket(Decerealizer packet)
	{
		auto tp = packet.value!TestPacket;

		writeln("Message: " ~ tp.message);
		//auto str = format("%s-%s-%s", y, m, d);
		//writefln("%s-%s-%s", y, m, d);

		return 0;
	}
}