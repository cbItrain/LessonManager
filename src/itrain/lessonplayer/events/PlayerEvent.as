package itrain.lessonplayer.events
{
	import flash.events.Event;
	
	public class PlayerEvent extends Event
	{
		public static const DEVELOPER_MODE_CHANGE:String = "PlayerEventDeveloperModeChange";
		public static const ACTION_CHANGE:String = "PlayerEventActionChange";
		public static const RIGHT_CLICK:String = "PlayerEventRightClick";
		
		public var data:Object;
		
		public function PlayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}