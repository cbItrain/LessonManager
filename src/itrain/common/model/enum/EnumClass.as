package itrain.common.model.enum
{
	public class EnumClass
	{
		public var name:String;
		public var ordinal:int;
		
		public function equals(o:Object):Boolean {
			return o is (Object(this).constructor as Class) && (o as EnumClass).ordinal == ordinal;
		}
	}
}