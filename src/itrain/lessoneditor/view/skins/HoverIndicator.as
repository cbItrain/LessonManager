package itrain.lessoneditor.view.skins
{
	import itrain.lessoneditor.model.CaptureVO;
	
	import mx.collections.IList;
	import mx.graphics.SolidColor;
	
	import spark.components.DataGrid;
	import spark.components.Grid;
	import spark.components.gridClasses.IGridVisualElement;
	import spark.primitives.Rect;
	
	public class HoverIndicator extends Rect implements IGridVisualElement
	{
		private var hoverIndicatorFill:SolidColor ;
		
		public function HoverIndicator()
		{
			super();
			hoverIndicatorFill = new SolidColor();
			this.fill = hoverIndicatorFill;
		}
		
		public function prepareGridVisualElement(grid:Grid, rowIndex:int, columnIndex:int):void
		{
			const dataGrid:DataGrid = grid.dataGrid;
			if (!dataGrid)
				return;
			const color:uint = dataGrid.getStyle("rollOverColor");
			hoverIndicatorFill.color = color;
		}
		
		private function showHover(grid:DataGrid, rowIndex:int):Boolean {
			var dp:IList = grid.dataProvider;
			return !(rowIndex < dp.length && (dp.getItemAt(rowIndex) as CaptureVO).source);
		}
	}
}