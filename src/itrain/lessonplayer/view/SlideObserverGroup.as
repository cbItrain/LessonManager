package itrain.lessonplayer.view
{
	import itrain.lessonplayer.control.PlayerController;
	import itrain.lessonplayer.model.PlayerModel;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	
	import spark.components.Group;
	
	public class SlideObserverGroup extends Group
	{
		[Bindable] [Inject]
		public var model:PlayerModel;
		[Bindable] [Inject]
		public var controller:PlayerController;
		
		private var _watcher:ChangeWatcher;
		
		[PostConstruct]
		public function onPostConstruct():void {
			_watcher = ChangeWatcher.watch(model, "currentlySelected", onSlideSelectionChange);
		}
		
		protected function onSlideSelectionChange(o:Object = null):void {
			
		}
	}
}