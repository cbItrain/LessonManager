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