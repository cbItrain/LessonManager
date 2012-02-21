package itrain.lessoneditor.model
{
	import flash.events.IEventDispatcher;
	import flash.utils.flash_proxy;
	
	import itrain.common.events.CaptureImporterEvent;
	import itrain.common.events.CaptureLoaderEvent;
	import itrain.common.model.ImageRepository;
	import itrain.lessoneditor.events.EditorEvent;
	import itrain.lessoneditor.view.renderers.CaptureSlideRenderer;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.utils.ObjectUtil;
	
	import spark.collections.Sort;
	import spark.collections.SortField;

	public class CaptureImportModel implements IImportModel
	{
		private var _captures:ArrayCollection;
		private var _captureSlides:ArrayCollection;
		private var _captureSort:Sort;
		private var _captureListFilter:EnumCaptureFilterOption=EnumCaptureFilterOption.LESSON;
		private var _slidesLoadingCaptureId:int = -1;

		private var _lessonId:int;
		private var _userId:String;
		private var _courseId:String;
		private var _comId:String;

		[Bindable]
		public var selectedCapture:CaptureVO;

		[Bindable]
		public var allSlidesSelected:EnumSelection;

		[Bindable]
		public var imageImportOnly:Boolean;

		[Dispatcher]
		public var dispatcher:IEventDispatcher;

		[Bindable]
		public var selectedSlidesCount:Number;

		[Bindable]
		public var onlyAssociatedCaptures:Boolean=true;

		[Bindable]
		public var loadingCaptureList:Boolean=false

		public function CaptureImportModel()
		{
			imageImportOnly=false;

			var p:Object=FlexGlobals.topLevelApplication.parameters;
			_lessonId=Number(p.lessonId);
			_userId=p.currentUserId;
			_courseId=p.courseId;
			_comId=p.companyId;

			_captureSort=new Sort();
			_captureSort.fields=[new SortField(null, true)];
			_captureSort.compareFunction=dateCompareFunction;
		}

		[Bindable]
		public function get captures():ArrayCollection
		{
			if (!_captures)
			{
				_captures=new ArrayCollection();
				loadCaptures();
			}
			return _captures;
		}

		public function set captures(value:ArrayCollection):void
		{
			_captures=value;
		}

		[Bindable]
		public function get captureSlides():ArrayCollection
		{
			if (selectedCapture)
			{
				unlistenForCaptureSlideChange();
				_captureSlides=selectedCapture.slides;
				listenForCaptureSlideChange();
				if (selectedCapture.slides.length == 0 && _slidesLoadingCaptureId != selectedCapture.id)
				{ //request capture slides
					_slidesLoadingCaptureId = selectedCapture.id;
					var ce:CaptureLoaderEvent=new CaptureLoaderEvent(CaptureLoaderEvent.LOAD_CAPTURE);
					ce.url=selectedCapture.source;
					dispatcher.dispatchEvent(ce);
				}
				else
				{
					onCapturesChange();
				}
			}
			return _captureSlides;
		}

		public function set captureSlides(value:ArrayCollection):void
		{
			_captureSlides=value;
		}

		[Mediate(event="CaptureLoaderEvent.CAPTURE_LOADED")]
		public function onCaptureSlide(ce:CaptureLoaderEvent):void
		{
			if (selectedCapture && selectedCapture.source == ce.url)
			{
				selectedCapture.slides.addAll(new ArrayCollection(ce.captures));
			}
			else
			{
				for each (var c:CaptureVO in captures)
				{
					if (c.source == ce.url)
					{
						c.slides.removeAll();
						c.slides.addAll(new ArrayCollection(ce.captures));
						break;
					}
				}
			}
			_slidesLoadingCaptureId = -1;
			selectedSlidesCount=ce.captures.length;
		}

		[Mediate(event="CaptureLoaderEvent.CAPTURE_LIST_LOADED")]
		public function onCapturesLoad(ce:CaptureLoaderEvent):void
		{
			if (!_captures)
				_captures=new ArrayCollection();

			addCaptures(ce.captures);
			loadingCaptureList=false;
		}

		public function removeCapture(c:CaptureVO):void
		{
			var index:int=_captures.getItemIndex(c);
			if (index > -1)
			{
				_captures.removeItemAt(index);
				_captures.sort=_captureSort;
				_captures.filterFunction=capturesFilterFunction;
				_captures.refresh();
			}
		}

		public function addCaptures(newCaptures:Array, uniqueOnly:Boolean=true):void
		{
			if (uniqueOnly)
			{
				for each (var c:CaptureVO in _captures.source)
				{
					for each (var nc:CaptureVO in newCaptures)
					{
						if (c.id == nc.id)
						{
							newCaptures.splice(newCaptures.indexOf(nc), 1);
							break;
						}
					}
				}
			}
			_captures.addAll(new ArrayCollection(newCaptures));
			_captures.sort=_captureSort;
			_captures.filterFunction=capturesFilterFunction;
			_captures.refresh();
		}

		public function setAllSlideSelection(value:Boolean):void
		{
			unlistenForCaptureSlideChange();
			for each (var sc:SlideCaptureVO in _captureSlides)
			{
				sc.selected=value;
			}
			listenForCaptureSlideChange();
			if (value)
			{
				allSlidesSelected=EnumSelection.SELECTED;
				selectedSlidesCount=_captureSlides.length;
			}
			else
			{
				allSlidesSelected=EnumSelection.UNSELECTED;
				selectedSlidesCount=0;
			}
		}

		public function importSelection(selectedOnly:Boolean):void
		{
			var ev:CaptureImporterEvent;
			if (selectedOnly)
			{
				ev=new CaptureImporterEvent(CaptureImporterEvent.IMPORT_SELECTED_CAPTURES, true);
			}
			else
			{
				ev=new CaptureImporterEvent(CaptureImporterEvent.IMPORT_ALL_CAPTURES, true);
			}
			ev.toImport=selectedCapture;
			ev.additionalData=imageImportOnly;
			dispatcher.dispatchEvent(ev);

			var capturesToClear:ArrayCollection=new ArrayCollection(captures.source.concat());
			capturesToClear.removeItemAt(capturesToClear.getItemIndex(selectedCapture));
			clearImageCache(capturesToClear);
		}

		public function onCloseWindow():void
		{

			selectedCapture=null;
			clearImageCache();
		}

		public function loadCaptures():void
		{
			selectedCapture=null;

			var ce:CaptureLoaderEvent=new CaptureLoaderEvent(CaptureLoaderEvent.LOAD_CAPTURE_LIST);
			ce.additionalData=onlyAssociatedCaptures;
			dispatcher.dispatchEvent(ce);

			loadingCaptureList=true;
		}

		private function clearImageCache(capturesToClear:ArrayCollection=null):void
		{
			var repository:ImageRepository=ImageRepository.getInstance();
			var array:Array=[];
			var collection:ArrayCollection;
			if (capturesToClear)
				collection=capturesToClear;
			else
				collection=captures;
			for each (var c:CaptureVO in collection)
			{
				if (c != selectedCapture)
				{
					for each (var sc:SlideCaptureVO in c.slides)
					{
						array.push(sc.source);
					}
				}
			}

			var e:EditorEvent=new EditorEvent(EditorEvent.REQUEST_CLEAR_CACHE, true);
			e.additionalData=array;
			dispatcher.dispatchEvent(e);
		}

		private function listenForCaptureSlideChange():void
		{
			if (_captureSlides)
			{
				_captureSlides.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCapturesChange);
			}
		}

		private function unlistenForCaptureSlideChange():void
		{
			if (_captureSlides)
			{
				_captureSlides.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCapturesChange);
			}
		}

		private function onCapturesChange(e:CollectionEvent=null):void
		{
			if (e && e.kind == CollectionEventKind.ADD)
			{
				allSlidesSelected=EnumSelection.SELECTED;
				return;
			}
			var selectedCount:int=0;
			for each (var sc:SlideCaptureVO in _captureSlides.source)
			{
				if (sc.selected)
					selectedCount++;
			}
			if (selectedCount == 0)
				allSlidesSelected=EnumSelection.UNSELECTED;
			else if (selectedCount == _captureSlides.length)
				allSlidesSelected=EnumSelection.SELECTED;
			else
				allSlidesSelected=EnumSelection.MIDDLE;
			selectedSlidesCount=selectedCount;
		}

		public function onObjectVisibilityChange(newValue:Boolean):void
		{
			imageImportOnly=newValue;
			CaptureSlideRenderer.showObjects=!imageImportOnly;
		}
		
		public function sendCaptureIssueReport(captureId:int, report:String):void {
			var cle:CaptureLoaderEvent = new CaptureLoaderEvent(CaptureLoaderEvent.SEND_REPORT, true);
			cle.additionalData = report;
			cle.id = captureId;
			dispatcher.dispatchEvent(cle);
		}

		public function setCaptureListFilter(value:EnumCaptureFilterOption):void
		{
			if (!value.equals(_captureListFilter))
			{
				_captureListFilter=value;
				_captures.refresh();
			}
		}

		private function capturesFilterFunction(item:CaptureVO):Boolean
		{
			if (item.source)
			{
				switch (_captureListFilter.ordinal)
				{
					case EnumCaptureFilterOption.COURSE.ordinal:
						return item.courseId == _courseId;
					case EnumCaptureFilterOption.LESSON.ordinal:
						return item.lessonId == _lessonId;
					case EnumCaptureFilterOption.MY.ordinal:
						return item.userId == _userId;
					default:
						return true;
				}
			}
			else
			{
				return true;
			}
		}

		private function onlyAssociatedCapturesFilter(item:CaptureVO):Boolean
		{
			return item.lessonId == _lessonId;
		}

		private function dateCompareFunction(a:CaptureVO, b:CaptureVO, fields:Array=null):int
		{
			if (a == null && b == null)
				return 0;
			else if (a == null)
				return -1;
			else if (b == null)
				return 1;
			else
				return -ObjectUtil.dateCompare(a.timeStamp, b.timeStamp);
		}
	}
}
