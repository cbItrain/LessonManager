package itrain.lessonplayer.view.elements {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.*;
	
	import itrain.common.model.enum.EnumPosition;
	import itrain.common.model.vo.CaptionVO;
	import itrain.common.utils.PositionUtils;
	
	import spark.core.SpriteVisualElement;
	
	public class Caption extends SpriteVisualElement {
		
		private var _bodyW:uint;
		private var _bodyH:uint;
		private var _corner:uint;
		private var _pointPos:EnumPosition;
		private var _pointB:uint;
		private var _pointL:uint;
		private var _pointI:uint;		
		private var _totalPointIndent:uint;
		private var _displayBefore:Boolean;
		
		
		private var _text:TextField;
		private var _textFormat:TextFormat;
		
		private var _fillColour:uint = 0xFFFFFF;
		private var _line:Object = {
			thickness:2,
			colour:0x000000,
			alpha:1, // Should always be 1, to hide where the point overlaps the body
			pixelHinting:true
		}
		
		public var data:Object;
		
//**********************************************************

		// All point information is optional.  No point will be drawn if it is not specified.
		public function Caption(c:CaptionVO) {
			
			super();
			this.x = Number(c.x);
			this.y = Number(c.y);
			this.addEventListener(MouseEvent.CLICK, captionMouseDown);
			_bodyW = c.width;
			_bodyH = c.height;
			_corner = c.cornerSize;
			_pointPos = c.pointPosition;
			_pointB = c.pointBase;
			_pointL = c.pointLength;
			_pointI = c.pointIndent;
			_displayBefore = c.display;
			updateTotalIndent();
			createText();
		}		
		// Function is used to render the bubble once it has been created.
		// It can be recalled after a setting has been changed.
		public function draw():void {
			graphics.clear();
			setLineStyle(_line.thickness, _line.colour);
			graphics.beginFill(_fillColour);
			var corner:uint = _corner * 2;
			graphics.drawRoundRect(0, 0, _bodyW, _bodyH, corner, corner);
			switch (_pointPos.ordinal) {
				case EnumPosition.TOP_LEFT.ordinal:
					drawPoint([_totalPointIndent, 0], [_totalPointIndent, -_pointL], [_totalPointIndent + _pointB, 0]);
					break;
				case EnumPosition.TOP_RIGHT.ordinal:
					drawPoint([_bodyW - _totalPointIndent, 0], [_bodyW - _totalPointIndent, -_pointL], [_bodyW - _totalPointIndent - _pointB, 0]);
					break;
				case EnumPosition.RIGHT_TOP.ordinal:
					drawPoint([_bodyW, _totalPointIndent], [_bodyW + _pointL, _totalPointIndent], [_bodyW, _totalPointIndent + _pointB]);
					break;
				case EnumPosition.RIGHT_BOTTOM.ordinal:
					drawPoint([_bodyW, _bodyH - _totalPointIndent], [_bodyW + _pointL, _bodyH - _totalPointIndent], [_bodyW, _bodyH - _totalPointIndent - _pointB]);
					break;
				case EnumPosition.BOTTOM_RIGHT.ordinal:
					drawPoint([_bodyW - _totalPointIndent, _bodyH], [_bodyW - _totalPointIndent, _bodyH + _pointL], [_bodyW - _totalPointIndent - _pointB, _bodyH]);
					break;
				case EnumPosition.BOTTOM_LEFT.ordinal:
					drawPoint([_totalPointIndent, _bodyH], [_totalPointIndent, _bodyH + _pointL], [_totalPointIndent + _pointB, _bodyH]);
					break;
				case EnumPosition.LEFT_BOTTOM.ordinal:
					drawPoint([0, _bodyH - _totalPointIndent], [-_pointL, _bodyH - _totalPointIndent], [0, _bodyH - _totalPointIndent - _pointB]);
					break;
				case EnumPosition.LEFT_TOP.ordinal:
					drawPoint([0, _totalPointIndent], [-_pointL, _totalPointIndent], [0, _totalPointIndent + _pointB]);
					break;	
			}
			graphics.endFill();
		}	
		// User must use setLineStyle instead of the usual graphics
		// setter functions, to ensure storage of values.
		public function setLineStyle(thickness:uint, colour:uint = 0):void {
			// Line seems to be rendered badly if line thickness is an odd number
			// greater than 5.  This small fix forces the number to be even instead.
			_line.thickness = ((thickness > 4 && (thickness % 2)) ? thickness - 1 : thickness);
			_line.colour = colour;
			graphics.lineStyle(_line.thickness, _line.colour, _line.alpha, _line.pixelHinting);
		}		
		public function get lineThickness():uint {
			return _line.thickness;
		}
		public function set lineThickness(size:uint):void {
			_line.thickness = size;
		}
		public function get lineColour():uint {
			return _line.colour;
		}
		public function set lineColour(colour:uint):void {
			_line.colour = colour;
		}
		public function get fillColour():uint {
			return _fillColour;
		}			
		public function set fillColour(colour:uint):void {
			_fillColour = colour;
		}
		public function get bodyWidth():uint {
			return _bodyW;
		}
		public function get bodyHeight():uint {
			return _bodyH;
		}
		public function forceBodyHeight(height:uint):void {
			_bodyH = height;
		}
		public function get cornerSize():uint {
			return _corner;
		}
		// This method can be used to set a point after the TextBubble has been
		// created, even if one was not originally defined in the constructor.
//		public function setPoint(position:String, baseWidth:uint = 0, length:uint = 0, indent:Number = NaN):void {
//			if (!PointPosition.isValid(position)) throw new Error("Invalid point position");
//			_pointPos = position;
//			_pointB = baseWidth;
//			_pointL = length;
//			_pointI = checkIndent(indent);
//			updateTotalIndent();
//		}
		
		public function get pointPosition():EnumPosition {
			return _pointPos;
		}
		public function get pointBase():uint {
			return _pointB;
		}
		public function get pointLength():uint {
			return _pointL;
		}
		public function get pointIndent():uint {
			return _pointI;
		}
		public function get displayBefore():Boolean {
			return _displayBefore;
		}
		public function set displayBefore(before:Boolean):void {
			_displayBefore = before;
		}
		public function get text():String {
			return _text.htmlText;
		}
		public function set text(value:String):void {
			_text.htmlText = value;// + '<br/><p align="right"><font color="#0000FF"><b><u>Continue »</u></b></font></p>';
			updateBodySize(); // Resize the body to fit the text
		}
		public function setTextFormat(font:String = "arial", size:uint = 12, colour:uint = 0, align:String = "left"):void {
			_textFormat.font = font;
			_textFormat.size = size;
			_textFormat.color = colour;
			_textFormat.align = align;
			updateTextFormat();
		}
		public function get textFont():String {
			return _textFormat.font;
		}
		public function set textFont(font:String):void {
			_textFormat.font = font;
			updateTextFormat();
		}
		public function get textSize():uint {
			return uint(_textFormat.size);
		}
		public function set textSize(size:uint):void {
			_textFormat.size = size;
			updateTextFormat();
		}
		public function get textColour():uint {
			return uint(_textFormat.color);
		}
		public function set textColour(colour:uint):void {
			_textFormat.color = colour;
			updateTextFormat();
		}
		public function get textAlign():String {
			return _textFormat.align;
		}
		public function set textAlign(alignment:String):void {
			_textFormat.align = alignment;
			updateTextFormat();
		}
		
//**********************************************************

		private function drawPoint(start:Array, tip:Array, base:Array):void {
			// Line across base in fill colour, to make point appear to join to body
			with (graphics) {
				lineStyle(_line.thickness, _fillColour);
				moveTo(start[0], start[1]);
				lineTo(base[0], base[1]);
				moveTo(start[0], start[1]);
				lineStyle(_line.thickness, _line.colour);
				lineTo(tip[0], tip[1]);
				lineTo(base[0], base[1]);
				lineStyle(0, 0, 0);
				lineTo(start[0], start[1]);
				lineStyle(_line.thickness, _line.colour);
			}
		}
		private function checkIndent(indent:Number):Number {
			return (isNaN(indent) ? (_corner * 0.25) : indent);
		}
		private function updateTotalIndent():void {
			_totalPointIndent = (_corner + _pointI);
		}
		private function updateBodySize():void {
			_bodyH = _text.height + (_corner * 2);
		}
		private function createText():void {
			_text = new TextField();
			_text.x = _corner;
			_text.y = _corner;
			_text.width = _bodyW - (_corner * 2);         
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.multiline = true;
			_text.selectable = false;
			_text.wordWrap = true;
			_textFormat = new TextFormat();
			setTextFormat();
			_text.defaultTextFormat = _textFormat;
			addChild(_text);
		}
		private function captionMouseDown(e:MouseEvent):void {
				var t:* = e.target;
				var p:* = t.parent;
				if (t is Caption || p is Caption) {
					if (p is Caption) t = p;
					unpausePlayback();
				}
			}
		private function unpausePlayback():void {
		}
		
		private function updateTextFormat():void {
			_text.setTextFormat(_textFormat);
			updateBodySize();
		}

	}
}