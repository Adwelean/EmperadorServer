module interfaces.ipacket;

private import vendor;

interface IPacket
{
	Cerealiser serialize();
}