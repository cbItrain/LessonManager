package itrain.common.model.vo
{
	import itrain.common.model.enum.EnumAction;
	import itrain.common.model.enum.EnumCursor;
	import itrain.common.utils.ActionUtils;
	import itrain.common.utils.CursorUtils;
	import itrain.common.utils.DataUtils;
	
	import mx.utils.ObjectProxy;

	[RemoteClass]
	public class HotspotVO extends SlideObjectVO
	{
		[Bindable] public var score:int;
		[Bindable] public var action:EnumAction;
		[Bindable] public var cursor:EnumCursor;
		
		public function HotspotVO() {
			super();
			
			unlistenForChange();
			
			this.width = 150.0;
			this.height = 40.0;
			this.action = EnumAction.LEFT_MOUSE;
			this.cursor = EnumCursor.POINTER;
			this.score = 0;
			
			listenForChange();
		}
		
		override public function clone():SlideObjectVO {
			var resultVO:HotspotVO = new HotspotVO();
			
			resultVO.unlistenForChange();
			
			copyTo(resultVO);
			resultVO.score = score;
			resultVO.action = action;
			
			resultVO.listenForChange();
			
			return resultVO;
		} 
		
		override protected function parseObjectProxy(op:ObjectProxy):void {
			super.parseObjectProxy(op);
			
			unlistenForChange();			
			
			this.action = ActionUtils.getAction(op.action);
			this.score = DataUtils.getNumberNotNaN(op.score);
			this.cursor = CursorUtils.getCursor(op.cursor);
			
			listenForChange();
		}
		
		public function convertToXML():XML {
			var hotspotTag:XML = <hotspot></hotspot>;
			
			appendToXML(hotspotTag);
			hotspotTag.appendChild(XMLList("<action>" + action.ordinal + "</action>"));
			hotspotTag.appendChild(XMLList("<score>" + score + "</score>"));
			hotspotTag.appendChild(XMLList("<cursor>" + cursor.ordinal + "</cursor>"));
			
			return hotspotTag;
		}
		
		public static function newInstanceFromProxy(op:ObjectProxy):HotspotVO {
			var result:HotspotVO = new HotspotVO();
			result.parseObjectProxy(op);
			return result;
		}
	}
}