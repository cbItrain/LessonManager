package itrain.lessoneditor.model
{
	import itrain.common.model.SlideCollectionAware;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectProxy;

	[Bindable]
	public class CaptureVO extends SlideCollectionAware
	{
		public var id:int = 0;
		public var lessonName:String = "";
		public var lessonId:int = 0;
		public var source:String;
		public var timeStamp:Date;
		public var userId:String;
		public var userName:String;
		public var courseId:String;
		public var courseName:String;
		public var comId:String;
		
		public function CaptureVO()
		{
		}
		
		public static function parse(o:ObjectProxy):CaptureVO {
			var result:CaptureVO = new CaptureVO();
			result.id = o.id;
			result.lessonName = o.lessonName;
			result.lessonId = Number(o.lessonId);
			if (isNaN(result.lessonId))
				result.lessonId = 0;
			result.source = o.source;
			result.timeStamp = new Date(o.timeStamp);
			result.userId = o.userId;
			result.userName = o.userDisplayName;
			result.courseId = o.courseId;
			result.courseName = o.courseName;
			result.comId = o.comId;
			return result;
		}
		
		override public function unlistenForChange():void {
			null;
		}
		
		override public function listenForChange():void {
			null;
		}
	}
}