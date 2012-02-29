package itrain.common.utils
{
	import itrain.common.model.vo.SlideObjectVO;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.core.UIComponent;

	public class ViewModelUtils
	{
		public static function bindViewModel(viewObject:UIComponent, model:SlideObjectVO, watchers:Vector.<ChangeWatcher>):void {
			
			watchers.push(BindingUtils.bindProperty(viewObject, "x", model, "x"));
			watchers.push(BindingUtils.bindProperty(viewObject, "y", model, "y"));
			watchers.push(BindingUtils.bindProperty(viewObject, "width", model, "width"));
			watchers.push(BindingUtils.bindProperty(viewObject, "height", model, "height"));
			watchers.push(BindingUtils.bindProperty(viewObject, "rotation", model, "rotation"));
			
			
			watchers.push(BindingUtils.bindProperty(model, "x", viewObject, "x"));
			watchers.push(BindingUtils.bindProperty(model, "y", viewObject, "y"));
			watchers.push(BindingUtils.bindProperty(model, "width", viewObject, "width"));
			watchers.push(BindingUtils.bindProperty(model, "height", viewObject, "height"));
			watchers.push(BindingUtils.bindProperty(model, "rotation", viewObject, "rotation"));
		}
		
		public static function unbind(watchers:Vector.<ChangeWatcher>):void {
			for each (var cw:ChangeWatcher in watchers) {
				cw.unwatch();
				cw.useWeakReference = true;
			}
			watchers.splice(0,watchers.length);
		}
	}
}