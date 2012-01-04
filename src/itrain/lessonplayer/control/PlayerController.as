package itrain.lessonplayer.control
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	
	import itrain.common.events.LessonLoaderEvent;
	import itrain.common.model.vo.SlideVO;
	import itrain.common.utils.DataUtils;
	import itrain.lessonplayer.events.PlayerEvent;
	import itrain.lessonplayer.events.ValidationEvent;
	import itrain.lessonplayer.model.PlayerModel;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;

	public class PlayerController
	{		
		private var _developerMode:Boolean = false;
		
		public var trackingFunction:String;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Inject]
		[Bindable]
		public var model:PlayerModel;
		
		[Bindable]
		public function get developerMode():Boolean {
			return _developerMode;
		}
		
		public function set developerMode(value:Boolean):void {
			_developerMode = value;
			if (dispatcher)
				dispatcher.dispatchEvent(new PlayerEvent(PlayerEvent.DEVELOPER_MODE_CHANGE, true));
		}
		
		public function PlayerController() {
			var params:Object = FlexGlobals.topLevelApplication.parameters; 
			developerMode = DataUtils.parseBoolean(params.developerMode);
			trackingFunction = params.trackingFunction;
		}
		
		public function selectSlideAt(index:uint):void {
			if (index < model.lesson.slides.length) {
				model.currentSlideIndex = index;
				model.currentlySelected = SlideVO(model.lesson.slides[index]);
			} else {
				model.currentSlideIndex = -1;
				model.currentlySelected = null;
			}
		}
		
		public function nextSlide():void{
			var newSlideNum:int = model.getNearestNextPointer(model.currentSlideIndex);
			//model.currentSlideIndex = model.lessonPointers[newSlideNum];
			selectSlideAt(model.lessonPointers[newSlideNum]);
		}
		public function previousSlide():void{
			var newSlideNum:int = model.getNearestPreviousPointer(model.currentSlideIndex);
			//model.currentSlideIndex = model.lessonPointers[newSlideNum];
			selectSlideAt(model.lessonPointers[newSlideNum]);
		}

		public function currentSlideFinished():void{
			if (model.lesson.slides.length > model.currentSlideIndex + 1){
				selectSlideAt(model.currentSlideIndex + 1);
			} else {
				// Call the javascript function to track completion of the page.
				dispatcher.dispatchEvent(new ValidationEvent(ValidationEvent.LESSON_COMPLETE));
				if (ExternalInterface.available){
					ExternalInterface.call(trackingFunction);
				}
			}
		}
	}
}