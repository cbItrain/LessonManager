/**
 *  Latest information on this project can be found at http://www.rogue-development.com/objectHandles.html
 *
 *  Copyright (c) 2009 Marc Hughes
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a
 *  copy of this software and associated documentation files (the "Software"),
 *  to deal in the Software without restriction, including without limitation
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the Software
 *  is furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 *  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 *  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 *  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 *  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 *  See README for more information.
 *
 **/


/**
 * A handle implementation based on Sprite, primarily for use in Flex 3.
 **/
package itrain.lessoneditor.other {	
	import flash.events.MouseEvent;
	
	import itrain.common.utils.Embeded;
	
	import mx.core.UIComponent;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;

	public class PointerHandle extends UIComponent {
		private static var COLOR:uint=0x0FCF012;
		private static var HOVER_COLOR:uint=0xcC5FFC0;
		private static var HOVER_LINE_COLOR:uint=0x3DFF40;
		
		protected var isOver:Boolean=false;
		
		private var _dragCursorId:int;
		private var _hoverCursorId:int = -1;
		private var _cursor:Class;

		public function PointerHandle() {
			super();
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			_cursor = Embeded.CAPTION_POS_CURSOR;
		}
		
		private function onMouseDown(me:MouseEvent):void {
			if (me.target == this) {
				showDragCursor();
				this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
			}
		}
		
		private function onMouseUp(me:MouseEvent):void {
			CursorManager.removeCursor(_dragCursorId);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);
		}

		protected function onRollOut(event:MouseEvent):void {
			isOver=false;
			redraw();
			if (_hoverCursorId != -1) {
				CursorManager.removeCursor(_hoverCursorId);
				_hoverCursorId = -1;
			}
		}

		protected function onRollOver(event:MouseEvent):void {
			isOver=true;
			redraw();
			if (!event.buttonDown) {
				showHoverCursor();
			}
		}
		
		private function showDragCursor():void {
			_dragCursorId = CursorManager.setCursor(_cursor, CursorManagerPriority.HIGH, -10.0, -5.0);
		}
		
		private function showHoverCursor():void {
			_hoverCursorId = CursorManager.setCursor(_cursor, CursorManagerPriority.HIGH, -10.0, -5.0);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			redraw();
		}

		public function redraw():void {
			graphics.clear();
			if (isOver) {
				graphics.lineStyle(1, 0x3dff40);
				graphics.beginFill(HOVER_COLOR, 1);
			} else {
				graphics.lineStyle(1, 0);
				graphics.beginFill(COLOR, 1);
			}
			graphics.drawCircle(0, 0, 5);
			graphics.endFill();

		}

	}
}