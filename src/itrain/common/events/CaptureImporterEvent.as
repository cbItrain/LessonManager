package itrain.common.events
{
	import flash.events.Event;
	
	import itrain.common.model.SlideCollectionAware;
	
	public class CaptureImporterEvent extends Event
	{
		public static const IMPORT_ALL_CAPTURES:String = "CaptureImporterEventImportAllCaptures";
		public static const IMPORT_SELECTED_CAPTURES:String = "CaptureImporterEventImportSelectedCaptures";
		public static const IMPORT_SELECTION_CHANGED:String = "CaptureImporterEventImportSelectionChanged";
		
		public var toImport:SlideCollectionAware;
		
		public var additionalData:Object;
		
		public function CaptureImporterEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}