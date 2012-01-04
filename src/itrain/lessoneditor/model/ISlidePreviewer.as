package itrain.lessoneditor.model
{
	[Bindable]
	public interface ISlidePreviewer
	{
		function showPreview():void;
		function hidePreview():void;
		
		function deselect():void;
		
		function set enablePreview(value:Boolean):void;
		function get enablePreview():Boolean;
	}
}