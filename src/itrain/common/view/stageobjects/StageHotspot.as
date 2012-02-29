package itrain.common.view.stageobjects
{
	import flash.geom.Point;
	
	import itrain.common.model.vo.HotspotVO;
	import itrain.common.model.vo.SlideObjectVO;
	import itrain.common.utils.HotspotUtils;
	import itrain.common.utils.ViewModelUtils;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.core.UIComponent;
	
	public class StageHotspot extends UIComponent implements IStageObject
	{
		public static var NEGATIVE_HOTSPOT_COLOR:uint = 0xFF0000;
		public static var POSITIVE_HOTSPOT_COLOR:uint = 0x06CE27;
		public static var NEUTRAL_HOTSPOT_COLOR:uint = 0x00AAFF;
		
		[Bindable]
		public var model:SlideObjectVO;
		
		private var _watchers:Vector.<ChangeWatcher>;
		
		public function StageHotspot(model:SlideObjectVO, visible:Boolean = true)
		{
			super();
			this.model = model;
			
			_watchers = new Vector.<ChangeWatcher>();
			ViewModelUtils.bindViewModel(this, model, _watchers);
			_watchers.push(ChangeWatcher.watch(model, "score", onScoreChange));
			
			doubleClickEnabled = true;
			updateVisibility(visible);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(e:Event):void {
			ViewModelUtils.unbind(_watchers);
			model = null;
		}
		
		private function onScoreChange(o:Object = null):void {
			this.invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var hotspotModel:HotspotVO = model as HotspotVO;
			var color:uint;
			
			if (hotspotModel.score == 0.0)
				color = NEUTRAL_HOTSPOT_COLOR;
			else if (hotspotModel.score > 0.0)
				color = POSITIVE_HOTSPOT_COLOR;
			else
				color = NEGATIVE_HOTSPOT_COLOR;
			graphics.clear();
			graphics.lineStyle(2.0, color);
			graphics.beginFill(color, .5);
			graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			graphics.endFill();
			
			HotspotUtils.drawCrosshair(graphics, new Point(unscaledWidth/2,unscaledHeight/2), 10.0, color, 1.0, 2.0);
		}
		
		public function updateVisibility(value:Boolean):void {
			alpha = value ? 1.0 : .001;
		}
		
		public function isOver(point:Point):Boolean {
			var ltglobal:Point = new Point(x,y);
			var rbglobal:Point = new Point(x + width, y + height);
			return point.x >= ltglobal.x && point.x <= rbglobal.x && point.y >= ltglobal.y && point.y <= rbglobal.y;
		}
	}
}