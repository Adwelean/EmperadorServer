module core.singleton;

mixin template Singleton(T)
{
	private static __gshared T _instance = null;

	public static @property T instance()
	{
		if(this._instance is null)
		{
			synchronized
			{
				this._instance = new T;
			}
		}

		return this._instance;
	}
}