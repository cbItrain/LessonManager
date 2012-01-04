package itrain.common.model
{
	import itrain.IRightClickAware;
	import itrain.common.model.vo.LessonVO;

	public interface ILessonPlayerModule extends IRightClickAware
	{
		function loadLesson(interactive:Boolean, sendParameters:Object = null):void;
		function playLesson(lesson:LessonVO, interactive:Boolean = false, developerMode:Boolean = false, startIndex:int = 0):void;
		function resetLesson():void;
		function beforeUnload():void;
		function next():Boolean;
		function nextEnabled():Boolean;
		function previous():Boolean;
		function previousEnabled():Boolean;
		function getSlideSelectionLabel():String;
		
		function set developerMode(value:Boolean):void;
		function get developerMode():Boolean;
	}
}