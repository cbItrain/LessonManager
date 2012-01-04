package itrain.common.model.vo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.events.PropertyChangeEvent;
	
	public class ChangeAwareModel extends EventDispatcher
	{
		
		public static var changeHandler:Function;
		
		public function ChangeAwareModel(target:IEventDispatcher=null)
		{
			super(target);
			
			listenForChange();
		}
		
		public function listenForChange():void {
			unlistenForChange();
			this.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
		}
		
		public function unlistenForChange():void {
			this.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
		}
		
		private function onPropertyChange(e:PropertyChangeEvent):void {
			if (changeHandler != null)
				changeHandler(e);
		}
	}
}