
import libasync;
import std.stdio;

import packets;
import core;
import parsers;
import vendor;
import network;

EventLoop evl;
Server listener;
bool closed;


int main(string[] argv)
{


    writeln("Hello D-World!");

	//auto packet = new HelloConnect();
	//writeln(packet.OpCode);

	auto cerealiser = Cerealiser(); //UK spelling
	cerealiser ~= cast(ushort)0x01; //int
	//cerealiser ~= cast(string)"test";

	writeln(cerealiser.bytes);

	auto decerealizer = Decerealizer(cerealiser.bytes); //US spelling works too
	auto val = decerealizer.value!TestPacket;
	writeln(val.message);
	/*writeln(decerealizer.value!ushort == 0x01);
	writeln(decerealizer.value!ubyte == 3);
	writeln(decerealizer.value!string == "test");
	writeln(decerealizer.value!ubyte == 4);
	writeln(decerealizer.value!string == "tept");
*/
	//PacketManager.instance.handle(cerealiser.bytes);

	//AuthenticatorParser.instance.parse(0x01, null);

	evl = new EventLoop;
	listener = new Server("localhost", 8081, evl);

	writeln("work");

	while(!closed)
		evl.loop();
	destroyAsyncThreads();

	readln();
    return 0;
}
