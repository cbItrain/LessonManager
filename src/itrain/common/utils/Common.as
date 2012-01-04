package itrain.common.utils
{
	
	import spark.filters.BlurFilter;
	import spark.filters.ConvolutionFilter;
	import spark.filters.DropShadowFilter;

	public class Common
	{
		public static const dropShadow:DropShadowFilter = new DropShadowFilter(5.0, 45, 0x444444, 0.8);
		public static const smallDropShadow:DropShadowFilter = new DropShadowFilter(3.0, 45, 0x444444, 0.7);
		public static const blurFilter:BlurFilter = new BlurFilter(8.0,8.0);
		public static const embossed:ConvolutionFilter = getEmbossedFilter();
		
		public static const IDLE_WINDOW_SHOW_INTERVAL:Number = 3000.0;
		
		private static function getEmbossedFilter():ConvolutionFilter {
			var f:ConvolutionFilter = new ConvolutionFilter();
			f.matrixX = 3;
			f.matrixY = 3;
			f.divisor = 1.5;
			f.matrix = [-2, -1, 0, -1, 1, 1, 0, 1, 2];
			return f;
		}
	}
}