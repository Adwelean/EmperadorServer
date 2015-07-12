module interfaces.ipacket;

private import vendor;

interface IPacket
{
	@property string Name();
	Cerealiser serialize();
	string toString();
}