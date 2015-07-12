module parsers.parserbase;

private import interfaces.ipacket;
private import vendor;

public class ParserBase
{
	private alias int delegate(Decerealizer) callbackFunction;

	public callbackFunction[uint] PacketsDictionary;

	this()
	{

		this.registerFunction();
	}

	public abstract void registerFunction();
	public void parse(uint packetID, Decerealizer packet)
	{

	}
}