package itrain.common.view.floatingtexteditor
{
	import mx.controls.RichTextEditor;
	import mx.core.mx_internal;
	
	public class HTMLTextFormatToolbar extends RichTextEditor
	{
		override public function HTMLTextFormatToolbar()
		{
			super();
			
			focusEnabled=false;			
			percentWidth=100;
			height=70;
			
			this.setStyle("headerHeight", 0);
			this.setStyle("borderSkin", null);
			this.setStyle("dropShadowVisible", false);
		}
		
		override public function initialize():void {
			super.initialize();
			textArea.focusEnabled = textArea.visible = textArea.includeInLayout = false;
			textArea.setStyle('focusThickness', 0);
		}
	}
}