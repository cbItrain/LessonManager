package itrain.common.utils.graphics {
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class ImageUtils {
		
		public static function getScaledBitmapData(originalBD:BitmapData, ratio:Number, useBicubic:Boolean = false):BitmapData {
			var result:BitmapData;
			if (!(originalBD == null || isNaN(ratio))) {
				var iOriginal:InterpolatedBitmapData=new InterpolatedBitmapData(originalBD.width, originalBD.height, originalBD.transparent);
				iOriginal.draw(originalBD);
				var targetHeight:int = Math.floor(originalBD.height / ratio);
				var targetWidth:int = Math.floor(originalBD.width / ratio);
				
				result=new BitmapData(targetWidth, targetHeight);

				var size:int=targetWidth * targetHeight;
				var i:int;
				var pixels:Vector.<uint>=new Vector.<uint>(size, true);

				var ox:uint;
				var oy:uint;


				result.lock();
				if (useBicubic) {
					pixels.forEach(function(item:uint, index:int, vector:Vector.<uint>):void {
						ox=index % targetWidth;
						oy=index / targetWidth;
						
						pixels[index]=0xFF000000 + iOriginal.getPixelBicubic(ox * ratio, oy * ratio);
					});
				} else {
					pixels.forEach(function(item:uint, index:int, vector:Vector.<uint>):void {
						ox=index % targetWidth;
						oy=index / targetWidth;
						
						pixels[index]=0xFF000000 + iOriginal.getPixelBilinear(ox * ratio, oy * ratio);
					});
				}
				result.setVector(result.rect, pixels);
				result.unlock();
			}
			return result;
		}
		
		
		private static const IDEAL_RESIZE_PERCENT:Number = .5;

		
		/**
		 * Return a new bitmap data object resized to the provided size.
		 * 
		 * @param The source bitmap data object to resize.
		 * @param The size the bitmap data object needs to be or needs to fit
		 * within.
		 * @param Whether to keep the proportions of the image or allow it to
		 * squish into the size.
		 * 
		 * @return A resized bitmap data object.
		 */
		public static function resizeImage(source:BitmapData, width:uint, height:uint, resizeStyle:String = "constrainProportions"):BitmapData
		{
			var bitmapData:BitmapData;
			var crop:Boolean = false;
			var fill:Boolean = false;
			var constrain:Boolean = false;
			switch (resizeStyle) {
				case ResizeStyle.CROP: // these are supposed to not have break; statements
					crop = true;
				case ResizeStyle.CENTER:
					fill = true;
				case ResizeStyle.CONSTRAIN_PROPORTIONS:
					constrain = true;
					break;
				case ResizeStyle.STRETCH:
					fill = true;
					break;
				default:
					throw new ArgumentError("Invalid resizeStyle provided. Use options available on the ImageResizeStyle lookup class");
			}
			
			// Find the scale to reach the final size
			var scaleX:Number = width/source.width;
			var scaleY:Number = height/source.height;
			
			if (width == 0 && height == 0) {
				scaleX = scaleY = 1;
				width = source.width;
				height = source.height;
			} else if (width == 0) {
				scaleX = scaleY;
				width = scaleX * source.width;
			} else if (height == 0) {
				scaleY = scaleX;
				height = scaleY * source.height;
			}
			
			if (crop) {
				if (scaleX < scaleY) scaleX = scaleY;
				else scaleY = scaleX;
			} else if (constrain) {
				if (scaleX > scaleY) scaleX = scaleY;
				else scaleY = scaleX;
			}
			
			var originalWidth:uint = source.width;
			var originalHeight:uint = source.height;
			var originalX:int = 0;
			var originalY:int = 0;
			var finalWidth:uint = Math.round(source.width*scaleX);
			var finalHeight:uint = Math.round(source.height*scaleY);
			
			if (fill) {
				originalWidth = Math.round(width/scaleX);
				originalHeight = Math.round(height/scaleY);
				originalX = Math.round((originalWidth - source.width)/2);
				originalY = Math.round((originalHeight - source.height)/2);
				finalWidth = width;
				finalHeight = height;
			}
			
			if (scaleX >= 1 && scaleY >= 1) {
				try {
					bitmapData = new BitmapData(finalWidth, finalHeight, true, 0);
				} catch (error:ArgumentError) {
					error.message += " Invalid width and height: " + finalWidth + "x" + finalHeight + ".";
					throw error;
				}
				bitmapData.draw(source, new Matrix(scaleX, 0, 0, scaleY, originalX*scaleX, originalY*scaleY), null, null, null, true);
				return bitmapData;
			}
			
			// scale it by the IDEAL for best quality
			var nextScaleX:Number = scaleX;
			var nextScaleY:Number = scaleY;
			while (nextScaleX < 1) nextScaleX /= IDEAL_RESIZE_PERCENT;
			while (nextScaleY < 1) nextScaleY /= IDEAL_RESIZE_PERCENT;
			
			if (scaleX < IDEAL_RESIZE_PERCENT) nextScaleX *= IDEAL_RESIZE_PERCENT;
			if (scaleY < IDEAL_RESIZE_PERCENT) nextScaleY *= IDEAL_RESIZE_PERCENT;
			
			bitmapData = new BitmapData(Math.round(originalWidth*nextScaleX), Math.round(originalHeight*nextScaleY), true, 0);
			bitmapData.draw(source, new Matrix(nextScaleX, 0, 0, nextScaleY, originalX*nextScaleX, originalY*nextScaleY), null, null, null, true);
			
			nextScaleX *= IDEAL_RESIZE_PERCENT;
			nextScaleY *= IDEAL_RESIZE_PERCENT;
			
			while (nextScaleX >= scaleX || nextScaleY >= scaleY) {
				var actualScaleX:Number = nextScaleX >= scaleX ? IDEAL_RESIZE_PERCENT : 1;
				var actualScaleY:Number = nextScaleY >= scaleY ? IDEAL_RESIZE_PERCENT : 1;
				var temp:BitmapData = new BitmapData(Math.round(bitmapData.width*actualScaleX), Math.round(bitmapData.height*actualScaleY), true, 0);
				temp.draw(bitmapData, new Matrix(actualScaleX, 0, 0, actualScaleY), null, null, null, true);
				bitmapData.dispose();
				nextScaleX *= IDEAL_RESIZE_PERCENT;
				nextScaleY *= IDEAL_RESIZE_PERCENT;
				bitmapData = temp;
			}
			
			return bitmapData;
		}
	}
}