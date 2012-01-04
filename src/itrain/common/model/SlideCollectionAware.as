package itrain.common.model
{
	import itrain.common.model.vo.ChangeAwareModel;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;

	[Bindable]
	public class SlideCollectionAware extends ChangeAwareModel
	{
		public var slides:ArrayCollection
		
		public function SlideCollectionAware()
		{
			unlistenForChange();
			
			slides = new ArrayCollection();
			
			listenForChange();
		}
		
		override public function listenForChange():void {
			super.listenForChange();
			if (slides)
				slides.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChangeEvent);
		}
		
		override public function unlistenForChange():void {
			super.unlistenForChange();
			if (slides)
				slides.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChangeEvent);
		}
		
		private function onCollectionChangeEvent(e:CollectionEvent):void {
			if (changeHandler != null)
				changeHandler(e);
		}
	}
}