module interfaces.iserver;

public interface IServer 
{
	void startListening();
	void stopListening();

	@property bool isAlive();

	void accept();

	//void ReceiveCallback(IAsyncResult result);

	//void Send(int id, BinaryWriter writer, bool close);

	void disconnectClient(int id);
}