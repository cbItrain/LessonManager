package itrain.common.utils
{
	import flash.display.Graphics;
	import flash.geom.Point;

	public class HotspotUtils
	{
		public static function drawCrosshair(graphics:Graphics, point:Point, size:Number = 10.0, color:uint = 0x000000, alpha:Number = 1.0, thickness:Number = 1.0):void {
			graphics.lineStyle(thickness,color,alpha);
			graphics.moveTo(point.x, point.y);
			var branch:Number = size / 2;
			graphics.lineTo(point.x, point.y - branch);
			graphics.moveTo(point.x, point.y);
			graphics.lineTo(point.x, point.y + branch);
			graphics.moveTo(point.x, point.y);
			graphics.lineTo(point.x - branch, point.y);
			graphics.moveTo(point.x, point.y);
			graphics.lineTo(point.x + branch, point.y);
			graphics.moveTo(point.x, point.y);
		}
	}
}