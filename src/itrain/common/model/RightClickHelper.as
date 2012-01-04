package itrain.common.model
{
	import flash.display.Stage;
	import flash.events.MouseEvent;

	public class RightClickHelper
	{
		private var _stage:Stage;
		private var _lastEventCopy:MouseEvent;
		
		public function init(stage:Stage):void {
			_stage = stage;
			addEventListeners();
		}
		
		public function uninit():void {
			removeEventListeners();
			_stage = null;
			_lastEventCopy = null;
		}
		
		public function getCurrentTarget():Object {
			return _lastEventCopy.target;
		}
		
		private function onMouseMove(e:MouseEvent):void {
			_lastEventCopy = e;
		}
		
		private function addEventListeners():void {
			removeEventListeners();
			if (_stage)
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function removeEventListeners():void {
			if (_stage)
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
	}
}