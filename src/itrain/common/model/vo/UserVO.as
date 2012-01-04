package itrain.common.model.vo
{
	import mx.utils.ObjectProxy;

	public class UserVO
	{
		public var author:String = "";
		public var companyId:String =  "";
		public var customerId:String = "";
		
		public function UserVO()
		{
		}
		
		public function parseObjectProxy(op:ObjectProxy):void {
			this.author = op.author;
			this.companyId = op.companyId;
			this.customerId = op.customerId;
		}
		
		public static function newInstanceFromProxy(op:ObjectProxy):UserVO {
			var result:UserVO=new UserVO();
			result.parseObjectProxy(op);
			return result;
		}
		
		public function convertToXML():XML {
			var userTag:XML = <user></user>;
			
			userTag.appendChild(XMLList("<author>" + author + "</author>"));
			userTag.appendChild(XMLList("<companyId>" + companyId + "</companyId>"));
			userTag.appendChild(XMLList("<customerId>" + customerId + "</customerId>"));

			return userTag;
		}
	}
}