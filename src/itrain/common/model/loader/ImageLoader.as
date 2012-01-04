package itrain.common.model.loader
{
	import flash.system.LoaderContext;
	
	import mx.controls.SWFLoader;
	
	public class ImageLoader extends SWFLoader
	{		
	
		public function ImageLoader()
		{
			super();
			this.loaderContext = new LoaderContext(true);
		}
	}
}