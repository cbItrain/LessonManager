package itrain.lessonplayer.view.elements
{
	import flash.geom.Point;
	
	import itrain.common.model.vo.HotspotVO;
	
	import spark.core.SpriteVisualElement;
	
	public class Hotspot extends SpriteVisualElement
	{
		private var _x:int;
		private var _y:int;
		private var _width:int;
		private var _height:int;
		
		public var modelReference:Object;
		
		public function Hotspot(h:HotspotVO)
		{
			_x = h.x;
			_y = h.y;
			_width = h.width;
			_height = h.height;
			modelReference = h;
		}
		
		public function draw(visible:Boolean = false):void {
			graphics.clear();
			graphics.lineStyle(1, 0xff0000, visible ? 1.0 : 0.0);
			graphics.beginFill(0xff0000, visible ? .5 : .01);
			graphics.drawRect(_x,_y,_width,_height);
			graphics.endFill();
		}
	}
}