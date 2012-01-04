package itrain.common.utils
{
	import itrain.common.model.vo.SlideObjectVO;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.UIComponent;

	public class ViewModelUtils
	{
		public static function bindViewModel(viewObject:UIComponent, model:SlideObjectVO):void {
			BindingUtils.bindProperty(viewObject, "x", model, "x");
			BindingUtils.bindProperty(viewObject, "y", model, "y");
			BindingUtils.bindProperty(viewObject, "width", model, "width");
			BindingUtils.bindProperty(viewObject, "height", model, "height");
			BindingUtils.bindProperty(viewObject, "rotation", model, "rotation");
			
			
			BindingUtils.bindProperty(model, "x", viewObject, "x");
			BindingUtils.bindProperty(model, "y", viewObject, "y");
			BindingUtils.bindProperty(model, "width", viewObject, "width");
			BindingUtils.bindProperty(model, "height", viewObject, "height");
			BindingUtils.bindProperty(model, "rotation", viewObject, "rotation");
		}
	}
}