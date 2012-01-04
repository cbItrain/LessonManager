package itrain.lessonplayer.model {
	import flash.external.ExternalInterface;
	
	import itrain.common.model.ILessonPlayerModule;
	
	import mx.core.FlexGlobals;

	public class ExternalInterfaceBean {
		public static const SLIDE_CHANGES:String = "SlideChanges";
		public static const PLAYER_READY:String = "PlayerReady";
		public static const LESSON_COMPLETE:String = "LessonComplete";
		
		
		private var _dispatcher:String;
		private var _flashVars:Object;
		private var _lessonPlayerModule:ILessonPlayerModule;
		
		public var standAlonePlayer:Boolean;

		public function ExternalInterfaceBean() {
			standAlonePlayer=FlexGlobals.topLevelApplication is IStandAlonePlayer;
			if (standAlonePlayer) {
				_flashVars = FlexGlobals.topLevelApplication.parameters;
				_dispatcher = _flashVars.dispatcherName;
			}
		}

		[Mediate(event="LessonModuleEvent.MODULE_CREATION_COMPLETE")]
		public function onPlayerCreationComplete():void {
			if (standAlonePlayer) {
				_lessonPlayerModule = (FlexGlobals.topLevelApplication as IStandAlonePlayer).lessonPlayerModule;
				addCallbacks(_flashVars);
			}
		}

		private function addCallbacks(flashVars:Object):void {
			if (ExternalInterface.available && flashVars) {
				if (flashVars.loadContentFunction)
					ExternalInterface.addCallback(flashVars.loadContentFunction, _lessonPlayerModule.loadLesson);
				if (flashVars.resetLessonFunction)
					ExternalInterface.addCallback(flashVars.resetLessonFunction, _lessonPlayerModule.resetLesson);
			}
		}

		public function dispatchEvent(name:String, ... params):Boolean {
			if (standAlonePlayer && ExternalInterface.available && _dispatcher) {
				ExternalInterface.call(_dispatcher, name, params);
				return true;
			}
			return false;
		}
	}
}