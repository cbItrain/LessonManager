package itrain.lessoneditor.model
{
	import flash.events.IEventDispatcher;
	
	import itrain.common.events.ModelEvent;
	import itrain.common.model.vo.CaptionVO;
	import itrain.common.model.vo.HighlightVO;
	import itrain.common.model.vo.HotspotVO;
	import itrain.common.model.vo.SlideObjectVO;
	import itrain.common.model.vo.SlideVO;
	import itrain.common.model.vo.TextFieldVO;
	import itrain.lessoneditor.events.EditorEvent;

	public class EditPanelModel
	{
		[Bindable] public var currentlySelected:SlideVO;
		[Bindable] public var loadingImage:Boolean;
		
		private var _selectedScale:Number = 100.0;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		[Bindable]
		public function set selectedScale(value:Number):void {
			_selectedScale = value;
			
			var ev:EditorEvent = new EditorEvent(EditorEvent.SCALE_CHANGE, true);
			dispatcher.dispatchEvent(ev);
		}
		
		public function get selectedScale():Number {
			return _selectedScale;
		}
		
		[Mediate(event="ModelEvent.SLIDE_SELECTION_CHANGE")]
		public function onSlideSelectionChange(me:ModelEvent):void {
			currentlySelected = me.slide;
		}
		
		[Mediate(event="EditorEvent.REMOVE_OBJECT")]
		public function onRemoveObject(ev:EditorEvent):void {
			var vo:SlideObjectVO = ev.model as SlideObjectVO;
			var slideVO:SlideVO = ev.additionalData as SlideVO;
			var index:int = -1;
			var array:Array;
			if (vo is HotspotVO) {
				array = slideVO.hotspots;
			} else if (vo is CaptionVO) {
				array = slideVO.captions;
			} else if (vo is TextFieldVO) {
				array = slideVO.textfields;
			} else if (vo is HighlightVO) {
				array = slideVO.highlights;
			}
			if (array) {
				index = array.indexOf(vo);
				if (index > -1)
					array.splice(index, 1);
			}
			var ee:EditorEvent = new EditorEvent(EditorEvent.OBJECT_REMOVED, true);
			ee.model = vo;
			ee.additionalData = slideVO;
			dispatcher.dispatchEvent(ee);
		}
		
	}
}