package itrain.common.view.stageobjects
{
	import flash.geom.Point;
	
	import itrain.common.model.vo.SlideObjectVO;

	public interface IStageObject
	{	
		function get model():SlideObjectVO;
		function set model(value:SlideObjectVO):void;
		
		function isOver(point:Point):Boolean;
	}
}