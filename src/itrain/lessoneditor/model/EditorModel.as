package itrain.lessoneditor.model {
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	
	import itrain.common.events.LessonConverterEvent;
	import itrain.common.events.LessonLoaderEvent;
	import itrain.common.events.ModelEvent;
	import itrain.common.model.ImageRepository;
	import itrain.common.model.vo.LessonVO;
	import itrain.common.model.vo.SlideVO;
	import itrain.lessoneditor.events.EditorEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;

	[Bindable]
	public class EditorModel {
		public var currentSlideIndex:Number;
		public var lesson:LessonVO;
		public var lessonName:String;

		public var addAtTheEnd:Boolean=true;
		public var insertionIndex:int=1;
		public var enableHints:Boolean=true;
		

		public var dataManipulationEnabled:Boolean=true;
		public var isSaving:Boolean=false;

		private var _closeHandler:String;
		private var _leaveAfterSave:Boolean=false;
		private var _enableSpell:Boolean=true;

		[Dispatcher]
		public var dispatcher:IEventDispatcher;

		[Inject]
		public var undoRedoBean:UndoRedoBean;

		public function EditorModel() {
			_closeHandler=FlexGlobals.topLevelApplication.parameters.closeFunction;
		}
		
		public function get enableSpell():Boolean {
			return _enableSpell;
		}
		
		public function set enableSpell(value:Boolean):void {
			_enableSpell = value;
			var ee:EditorEvent = new EditorEvent(EditorEvent.SPELL_CHECK_CHANGES, true);
			ee.additionalData = value;
			dispatcher.dispatchEvent(ee);
		}

		[Mediate(event="LessonLoaderEvent.LESSON_LOADED")]
		public function lessonLoaded(e:LessonLoaderEvent):void {
			lesson=e.lesson;
			lessonName=e.lessonName;
			if (lesson.slides.length == 0) {
				var ee:EditorEvent=new EditorEvent(EditorEvent.SHOW_CAPTURE_IMPORTER, true);
				ee.additionalData=true;
				dispatcher.dispatchEvent(ee);
			} else {
				dataManipulationEnabled=true;
			}
			currentSlideIndex=0;
		}

		[Mediate(event="LessonLoaderEvent.LOAD_LESSON")]
		public function onLoadLesson():void {
			dataManipulationEnabled=false;
		}

		[Mediate(event="ModelEvent.SLIDE_SELECTION_CHANGE")]
		public function onSlideSelectionChange(me:ModelEvent):void {
			currentSlideIndex=me.slideIndex;
			insertionIndex=currentSlideIndex + 1;
		}

		[Mediate(event="LessonConverterEvent.ADD_SLIDES")]
		public function onAddSlides(e:LessonConverterEvent):void {
			if (e.slides && e.slides.length) {
				var addIndex:int;
				if (addAtTheEnd) {
					addIndex=lesson.slides.length;
				} else {
					addIndex=insertionIndex;
				}
				lesson.slides.addAllAt(new ArrayCollection(e.slides), addIndex);

				var me:ModelEvent=new ModelEvent(ModelEvent.CHANGE_SLIDE_SELECTION, true);
				me.slideIndex=addIndex;
				dispatcher.dispatchEvent(me);
				dataManipulationEnabled=lesson.slides.length != 0;
			}
		}

		[Mediate(event="EditorEvent.REQUEST_CLEAR_CACHE")]
		public function onRequestClearCache(e:EditorEvent):void {
			var array:Array=e.additionalData as Array;
			var index:int;
			if (lesson) {
				for each (var s:SlideVO in lesson.slides) {
					index=array.indexOf(s.source);
					if (index > -1) {
						array.splice(index, 1);
					}
				}
				ImageRepository.getInstance().clearCache(array);
			}
		}


		[Mediate(event="LessonLoaderEvent.LESSON_SAVED")]
		public function onLessonSaved():void {
			isSaving = false;
			if (_leaveAfterSave) {
				externalClose(false);
			}
		}

		public function saveLesson():void {
			isSaving = true;
			var ev:LessonLoaderEvent=new LessonLoaderEvent(LessonLoaderEvent.SAVE_LESSON);
			ev.lesson=lesson;
			dispatcher.dispatchEvent(ev);
		}

		public function unload():Boolean {
			if (undoRedoBean.saveRequired) {
				close();
				return false;
			} else {
				return true;
			}
		}
		
		public function close():void {
			if (undoRedoBean.saveRequired) {
				Alert.show("You have unsaved changes.\nWould you like to save them before leaving the application?", "Closing application", Alert.YES | Alert.NO | Alert.CANCEL, FlexGlobals.topLevelApplication as Sprite, function(e:CloseEvent):void {
					if (e.detail == Alert.YES) {
						_leaveAfterSave=true;
						saveLesson();
					} else if (e.detail == Alert.NO) {
						externalClose(false);
					}
				});
			} else {
				externalClose(false);
			}
		}

		private function externalClose(checkSaveStatus:Boolean = true):void {
			if (ExternalInterface.available && _closeHandler) {
				ExternalInterface.call(_closeHandler, checkSaveStatus);
			}
		}

	}
}