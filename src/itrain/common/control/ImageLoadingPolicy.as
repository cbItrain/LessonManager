package itrain.common.control {
	import itrain.common.events.ImageRepositoryEvent;
	import itrain.common.events.LessonLoaderEvent;
	import itrain.common.events.ModelEvent;
	import itrain.common.model.ImageRepository;
	import itrain.common.model.vo.SlideVO;

	public class ImageLoadingPolicy {
		private var _loaded:Vector.<String>=new Vector.<String>();
		private var _toLoad:Vector.<String>=new Vector.<String>();

		public var repository:ImageRepository=ImageRepository.getInstance();

		private var _currentSlideIndex:int;
		private var _slides:Array;

		public function ImageLoadingPolicy() {
			repository.addEventListener(ImageRepositoryEvent.IMAGE_LOADED, onImageLoaded);
			repository.addEventListener(ImageRepositoryEvent.CACHE_CLEARED, onCacheRepositoryCleared);
		}

		public function onImageLoaded(e:ImageRepositoryEvent=null):void {
			if (e && _toLoad.indexOf(e.url) > -1) {
				_loaded.push(e.url);
			}
			if (!repository.cacheLimitReached()) {
				if (_toLoad.length > _loaded.length) {
					if (!repository.isLoading()) {
						var slideIndexToLoad:int=_currentSlideIndex + 1;
						if (slideIndexToLoad < _slides.length) {
							var continueSearch:Boolean=isLoaded((_slides[slideIndexToLoad] as SlideVO).source);
							var loopCount:int=0;
							while (continueSearch && (slideIndexToLoad < _slides.length - 1)) {
								slideIndexToLoad=(slideIndexToLoad + 1) % _slides.length;
								continueSearch=isLoaded((_slides[slideIndexToLoad] as SlideVO).source);
								loopCount++;
							}
							if (!continueSearch)
								repository.imageData((_slides[slideIndexToLoad] as SlideVO).source, false);
						}
					}
				}
			}
		}

		private function onCacheRepositoryCleared(ire:ImageRepositoryEvent):void {
			var toRemove:Array=ire.data as Array;
			var index:int;
			for each (var s:String in toRemove) {
				index=_loaded.indexOf(s);
				if (index > -1)
					_loaded.splice(index, 1);
			}
			if (!ire.url)
				onImageLoaded();
		}

		[Mediate(event="LessonLoaderEvent.LOAD_LESSON")]
		public function loadLesson(e:LessonLoaderEvent):void {
			_slides=[];
			if (_toLoad.length)
				_toLoad.splice(0, _toLoad.length);
			if (_loaded.length)
				_loaded.splice(0, _loaded.length);
		}

		[Mediate(event="LessonLoaderEvent.LESSON_LOADED")]
		public function lessonLoaded(e:LessonLoaderEvent):void {
			_slides=e.lesson.slides.source;
			for each (var s:SlideVO in _slides) {
				if (_toLoad.indexOf(s.source) < 0 && !isLoaded(s.source))
					_toLoad.push(s.source);
			}
		}

		[Mediate(event="ModelEvent.SLIDE_SELECTION_CHANGE")]
		public function currentSlideIndexChange(e:ModelEvent):void {
			_currentSlideIndex=e.slideIndex;
		}

		private function isLoaded(url:String):Boolean {
			return _loaded.indexOf(url) != -1;
		}
	}
}