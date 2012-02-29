package itrain.lessonplayer.model {
	import flash.events.IEventDispatcher;
	
	import itrain.common.events.LessonLoaderEvent;
	import itrain.common.events.ModelEvent;
	import itrain.common.model.ImageRepository;
	import itrain.common.model.vo.LessonVO;
	import itrain.common.model.vo.SlideVO;
	import itrain.common.utils.DataUtils;
	import itrain.lessonplayer.events.ValidationEvent;
	import itrain.lessonplayer.view.itemrenderers.MinimizedItemRenderer;
	
	import mx.core.FlexGlobals;

	[Bindable]
	public class PlayerModel {
		public var interactive:Boolean;
		public var lessonId:String="";
		public var lesson:LessonVO;
		public var currentlySelected:SlideVO;
		public var lessonPointers:Array;
		public var lessonReady:Boolean=false;
		public var loadingImage:Boolean=false;
		public var imageWidth:Number;
		public var imageHeight:Number;
		public var allowScale:Boolean=true;
		public var showToolBar:Boolean = true;

		public var displayMessage:String="";

		private var lessonEmptyMsg:String;
		private var imageRepository:ImageRepository=ImageRepository.getInstance();

		[Dispatcher]
		public var dispatcher:IEventDispatcher;

		private var _currentSlideIndex:int=0;

		public function PlayerModel() {
			this.interactive=DataUtils.parseBoolean(FlexGlobals.topLevelApplication.parameters.interactive as String);
			this.allowScale=DataUtils.parseBoolean(FlexGlobals.topLevelApplication.parameters.allowScale as String);

			lessonEmptyMsg=FlexGlobals.topLevelApplication.parameters.emptyLessonMsg;
			showToolBar = DataUtils.parseBoolean(FlexGlobals.topLevelApplication.parameters.showToolBar);
			if (!lessonEmptyMsg) {
				lessonEmptyMsg="Lesson is empty";
			}
			displayMessage=lessonEmptyMsg;
		}

		public function get currentSlideIndex():int {
			return _currentSlideIndex;
		}

		public function set currentSlideIndex(value:int):void {
			_currentSlideIndex=value;

			if (FlexGlobals.topLevelApplication is LessonPlayer)
				removePreviousImageFromCache();

			var me:ModelEvent=new ModelEvent(ModelEvent.SLIDE_SELECTION_CHANGE);
			me.slideIndex=value;
			dispatcher.dispatchEvent(me);
		}

		[Mediate(event="LessonLoaderEvent.LESSON_LOADED")]
		public function lessonLoaded(e:LessonLoaderEvent):void {
			this.lessonId=e.lessonId;
			this.lessonPointers=[];
			this.lesson=e.lesson;
			var s:SlideVO;
			var i:int;
			if (interactive) {
				for (i=0; i < lesson.slides.length; i++) {
					s=lesson.slides[i];
					if (s.interText)
						lessonPointers.push(i);
				}
			} else {
				for (i=0; i < lesson.slides.length; i++) {
					s=lesson.slides[i];
					if (s.captions.length > 0)
						lessonPointers.push(i);
				}
				if (!(lessonPointers.length && lessonPointers[0] == 0) && lesson.slides.length) {
					lessonPointers.unshift(0);
				}
			}
			lessonReady=true;
			if (lesson.slides && lesson.slides.length) {
				if (!e.sendParameters) {
					currentSlideIndex=0;
					currentlySelected=lesson.slides[0];
				} else {
					var newIndex:int = 0;
					if (lessonPointers.indexOf(e.sendParameters) > -1) {
						newIndex = e.sendParameters as int;
					} else {
						newIndex = getNearestPreviousPointer(e.sendParameters as int);
					}
					if (newIndex > -1 && newIndex < lesson.slides.length) {
						currentSlideIndex=newIndex;
						currentlySelected=lesson.slides[newIndex];
					}
				}
			} else {
				currentlySelected=null;
				currentSlideIndex=0;
				displayMessage=lessonEmptyMsg;
				dispatcher.dispatchEvent(new ValidationEvent(ValidationEvent.LESSON_COMPLETE));
			}
			MinimizedItemRenderer.oldStyleCaption=lesson.oldCaptionStyle;
			var newEvent:Event=new ModelEvent(ModelEvent.LESSON_READY);
			dispatcher.dispatchEvent(newEvent);
		}

		public function getFirstSlideIndex():int {
			if (lessonPointers.length)
				return lessonPointers[0];
			else
				return -1;
		}

		[Mediate(event="LessonLoaderEvent.LESSON_LOAD_FAULT")]
		public function lessonLoadedFault(e:LessonLoaderEvent):void {
			displayMessage=e.sendParameters.content as String;
		}

		private function removePreviousImageFromCache():void {
			if (_currentSlideIndex > 0) {
				var previousImageUrl:String=(lesson.slides.getItemAt(_currentSlideIndex - 1) as SlideVO).source;
				var currentImageUrl:String=(lesson.slides.getItemAt(_currentSlideIndex) as SlideVO).source;
				if (previousImageUrl != currentImageUrl)
					imageRepository.clearCache([previousImageUrl]);
			}
		}
		
		public function getNearestPreviousPointer(index:int):int {
			var newSlideNum:int = lessonPointers[lessonPointers.length-1];
			for (var i:int = lessonPointers.length-1, ix:int = 0; i >= 0; i--){
				if (lessonPointers[i] < index){
					newSlideNum = i;
					break;
				}
			}
			return newSlideNum;
		}
		
		public function getNearestNextPointer(index:int):int {
			var newSlideNum:int = 0;
			for (var i:int = 0, ix:int = lessonPointers.length; i < ix; i++){
				if (lessonPointers[i] > index){
					newSlideNum = i;
					break;
				}
			}
			return newSlideNum;
		}
		
		public function clean():void {
			imageRepository.clearAllCache();
		}
	}
}