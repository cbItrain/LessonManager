package itrain.common.utils
{
	import itrain.common.model.vo.SlideObjectVO;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.UIComponent;

	public class ViewModelUtils
	{
		public static function bindViewModel(viewObject:UIComponent, model:SlideObjectVO):void {
			BindingUtils.bindProperty(viewObject, "x", model, "x", false, true);
			BindingUtils.bindProperty(viewObject, "y", model, "y", false, true);
			BindingUtils.bindProperty(viewObject, "width", model, "width", false, true);
			BindingUtils.bindProperty(viewObject, "height", model, "height", false, true);
			BindingUtils.bindProperty(viewObject, "rotation", model, "rotation", false, true);
			
			
			BindingUtils.bindProperty(model, "x", viewObject, "x", false, true);
			BindingUtils.bindProperty(model, "y", viewObject, "y", false, true);
			BindingUtils.bindProperty(model, "width", viewObject, "width", false, true);
			BindingUtils.bindProperty(model, "height", viewObject, "height", false, true);
			BindingUtils.bindProperty(model, "rotation", viewObject, "rotation", false, true);
		}
	}
}