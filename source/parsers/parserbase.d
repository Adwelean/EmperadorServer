module parsers.parserbase;

import interfaces.ipacket;
import cerealed: Cerealizer, Decerealizer;
import network: Client;

public class ParserBase
{
	private alias int delegate(Decerealizer) callbackFunction;

	protected Client client;

	public callbackFunction[uint] PacketsDictionary;

	this()
	{

		this.registerFunction();
	}

	public abstract void registerFunction();
	public void parse(Client client, uint packetID, Decerealizer packet)
	{
		this.client = client;
	}
}