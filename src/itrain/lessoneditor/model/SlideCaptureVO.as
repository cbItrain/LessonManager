package itrain.lessoneditor.model
{
	import itrain.common.model.vo.HotspotVO;
	
	import mx.utils.ObjectProxy;

	[Bindable]
	public class SlideCaptureVO
	{
		private static const HOTSPOT_DIMENSION:int = 60;
		
		public var source:String;
		
		public var selected:Boolean = true;
		
		public var hotspot:HotspotVO;
		
		public static function parse(o:ObjectProxy):SlideCaptureVO {
			var result:SlideCaptureVO = new SlideCaptureVO();
			result.source = o.path;
			parseEvent(o.event, result);
			return result;
		}
		
		private static function parseEvent(event:ObjectProxy, slideCapture:SlideCaptureVO):void {
			if (event) {
				if (event.x && event.y) {
					var h:HotspotVO = new HotspotVO();
					h.unlistenForChange();
					h.height = h.width = HOTSPOT_DIMENSION;
					
					h.x = event.x - .5 * h.width;
					h.y = event.y - .5 * h.height;	
			
					h.action = CaptureUtils.translateCaptureAction(event.action);
					
					h.listenForChange();
					slideCapture.hotspot = h;
				}
			}
		}
	}
}