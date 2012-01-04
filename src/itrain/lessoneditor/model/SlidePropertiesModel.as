package itrain.lessoneditor.model {
	import flash.events.IEventDispatcher;
	
	import itrain.common.events.ModelEvent;
	import itrain.common.model.vo.CaptionVO;
	import itrain.common.model.vo.HighlightVO;
	import itrain.common.model.vo.HotspotVO;
	import itrain.common.model.vo.SlideObjectVO;
	import itrain.common.model.vo.SlideVO;
	import itrain.common.model.vo.TextFieldVO;
	import itrain.lessoneditor.events.EditorEvent;

	public class SlidePropertiesModel {
		[Bindable]
		public var currentlySelected:SlideVO;

		[Dispatcher]
		public var dispatcher:IEventDispatcher;

		[Mediate(event="ModelEvent.SLIDE_SELECTION_CHANGE")]
		public function onSlideSelectionChange(me:ModelEvent):void {
			currentlySelected=me.slide;
		}

		[Mediate(event="EditorEvent.ADD_OBJECT")]
		public function onAddObject(ev:EditorEvent):void {
			var vo:SlideObjectVO=ev.model as SlideObjectVO;
			var slideVO:SlideVO = ev.additionalData as SlideVO;
			if (vo) {
				if (vo is CaptionVO)
					slideVO.captions.push(vo);
				else if (vo is HotspotVO)
					slideVO.hotspots.push(vo);
				else if (vo is TextFieldVO)
					slideVO.textfields.push(vo);
				else if (vo is HighlightVO) {
					slideVO.highlights.push(vo);
				}
				var ee:EditorEvent=new EditorEvent(EditorEvent.OBJECT_ADDED, true);
				ee.model=vo;
				ee.additionalData=slideVO;
				dispatcher.dispatchEvent(ee);
			}
		}


		[Mediate(event="EditorEvent.PREPARE_OBJECT")]
		public function onPrepareObject(ee:EditorEvent):void {
			if (ee.model is HighlightVO && currentlySelected.highlights.length)
				copyHighlightProperties(currentlySelected.highlights[currentlySelected.highlights.length - 1] as HighlightVO, ee.model as HighlightVO, true);

		}

		private function copyHighlightProperties(from:HighlightVO, to:HighlightVO, silently:Boolean=true):void {
			if (silently)
				to.unlistenForChange();
			to.animationSpeed=from.animationSpeed;
			to.borderAlpha=from.borderAlpha;
			to.borderWidth=from.borderWidth;
			to.borderColor=from.borderColor;
			to.fillAlpha=from.fillAlpha;
			to.fillColor=from.fillColor;
			to.cornerRadius=from.cornerRadius;
			if (silently)
				to.listenForChange();
		}

	}
}