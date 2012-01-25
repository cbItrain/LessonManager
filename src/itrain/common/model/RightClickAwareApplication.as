package itrain.common.model {
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.ui.ContextMenu;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	
	import spark.components.Application;

	public class RightClickAwareApplication extends Application {

		private static var _callbackAlreadyAdded:Boolean=false;
		private static var _isListening:Boolean=false;
		private static var _rightClickHelper:RightClickHelper=new RightClickHelper();
		
		private var _moduleLoadInformer:String = null;

		public function RightClickAwareApplication() {
			super();
			usePreloader = false;
			this.addEventListener(FlexEvent.INITIALIZE, onInitialize);
			this.addEventListener(FlexEvent.APPLICATION_COMPLETE, onApplicationComplete);
		}

		protected function onApplicationComplete(e:Event=null):void {
			if (!_callbackAlreadyAdded) {
				ExternalInterface.addCallback("rightClick", onRightClick);
				_callbackAlreadyAdded=true;
				MacMouseWheelHandler.init(stage);
			}
		}

		protected function onRightClick():void {
			//to be implemented when inherited
		}

		protected function getRightClickTarget():Object {
			return _rightClickHelper.getCurrentTarget();
		}

		public function listenForRightClick():void {
			if (ExternalInterface.available && !_isListening) {
				_isListening=true;
				ExternalInterface.call("interceptRightClick");
				_rightClickHelper.init(stage);
			}
		}

		public function unListenForRightClick():void {
			if (ExternalInterface.available && _isListening) {
				_isListening=false;
				ExternalInterface.call("uninterceptRightClick");
				_rightClickHelper.uninit();
			}
		}
		
		private function onInitialize(e:Event):void {
			_moduleLoadInformer = parameters.moduleLoadInformer;
			
			if (parameters.fontsURL)
				styleManager.loadStyleDeclarations(parameters.fontsURL);
		}
		
		protected function informMLI(message:String):void {
			if (_moduleLoadInformer && ExternalInterface.available) {
				ExternalInterface.call(_moduleLoadInformer, message);
			}
		}
		
		protected function onProgress(me:ModuleEvent):void {
			var progress:Number = Math.round(me.bytesLoaded/me.bytesTotal*1000)/10;
			informMLI(progress.toString());
		}
		
		protected function onLoading(e:Event):void {
			informMLI("start");
		}
		
		protected function onReady(me:ModuleEvent):void {
			informMLI("end");
		}
		
		protected function onModuleCreationComplete(e:Event):void {
			informMLI("complete");
		}
	}
}