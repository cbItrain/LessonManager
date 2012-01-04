package itrain.lessoneditor.utils {
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	
	import flashx.textLayout.elements.TextFlow;
	
	import itrain.common.model.enum.EnumDisplay;
	import itrain.common.model.enum.EnumPosition;
	import itrain.common.model.vo.CaptionVO;
	import itrain.common.view.SpeechBubble;
	import itrain.common.view.stageobjects.StageCaption;
	import itrain.common.view.stageobjects.StageTextArea;
	
	import mx.core.UIComponent;
	import mx.effects.Effect;
	import mx.effects.Parallel;
	import mx.events.EffectEvent;
	
	import spark.components.RichEditableText;
	import spark.effects.Move;
	import spark.effects.Scale;

	public class CaptionUtils {
		public static var CAPTION_BORDER_COLOR:uint=0x888888;
		public static var CAPTION_COLOR_TOP:uint=0xE0E0E0;
		public static var CAPTION_COLOR_BOTTOM:uint=0xFFFFFF;

		public static var OLD_CAPTION_BORDER_COLOR:uint=0x000000;
		public static var OLD_CAPTION_COLOR_TOP:uint=0xFFFFFF;
		public static var OLD_CAPTION_COLOR_BOTTOM:uint=0xFFFFFF;
		
		public static var HOVER_BODY_COLOR:uint = 0xC5FFC0;
		public static var HOVER_BORDER_COLOR:uint = 0x3DFF40;
		
		public static function getCaptionShowHideEffect(sc:StageCaption, hide:Boolean, point:Point, endHandler:Function = null, duration:Number = 500):Effect {
			var result:Parallel = new Parallel();
			var move:Move = new Move();
			var scale:Scale = new Scale();
			result.addChild(move);
			result.addChild(scale);
			
			result.duration = duration;
			result.target = sc;
			
			if (endHandler != null)
				result.addEventListener(EffectEvent.EFFECT_END, endHandler);
			
			if (hide) {
				move.xFrom = sc.lastX;
				move.yFrom = sc.lastY;
				move.xTo = point.x;
				move.yTo = point.y;
				scale.scaleXFrom = 1.0;
				scale.scaleXTo = 0.0;
				scale.scaleYFrom = 1.0;
				scale.scaleYTo = 0.0;
			} else {
				move.xFrom = point.x;
				move.yFrom = point.y;
				move.xTo = sc.lastX;
				move.yTo = sc.lastY;
				scale.scaleXFrom = 0.0;
				scale.scaleXTo = 1.0;
				scale.scaleYFrom = 0.0;
				scale.scaleYTo = 1.0;
			}
			return result;
		}
		
		public static function getBubbleDetails(caption:CaptionVO, width:Number, height:Number):Object {
			var point:Point;
			var rectangle:Rectangle;
			switch (caption.pointPosition.ordinal) {
				case EnumPosition.BOTTOM_LEFT.ordinal:
					point=new Point(.2 * width, height);
					rectangle=new Rectangle(0.0, 0.0, width, .8 * height);
					break;
				case EnumPosition.BOTTOM_RIGHT.ordinal:
					point=new Point(.8 * width, height);
					rectangle=new Rectangle(0.0, 0.0, width, .8 * height);
					break;
				case EnumPosition.LEFT_BOTTOM.ordinal:
					point=new Point(0.0, .8 * height);
					rectangle=new Rectangle(.2 * width, 0.0, .8 * width, height);
					break;
				case EnumPosition.LEFT_TOP.ordinal:
					point=new Point(0.0, .2 * height);
					rectangle=new Rectangle(.2 * width, 0.0, .8 * width, height);
					break;
				case EnumPosition.TOP_LEFT.ordinal:
					point=new Point(.2 * width, 0.0);
					rectangle=new Rectangle(0.0, .2 * height, width, .8 * height);
					break;
				case EnumPosition.TOP_RIGHT.ordinal:
					point=new Point(.8 * width, 0.0);
					rectangle=new Rectangle(0.0, .2 * height, width, .8 * height);
					break;
				case EnumPosition.RIGHT_TOP.ordinal:
					point=new Point(width, .2 * height);
					rectangle=new Rectangle(0.0, 0.0, .8 * width, height);
					break;
				case EnumPosition.RIGHT_BOTTOM.ordinal:
					point=new Point(width, .8 * height);
					rectangle=new Rectangle(0.0, 0.0, .8 * width, height);
					break;
				case EnumPosition.NONE.ordinal:
					point=new Point(width / 2, 0.0);
					rectangle=new Rectangle(0.0, 0.0, width, height);
					break;
			}
			return {point:point, rectangle:rectangle};
		}
		
		public static function drawSpeachBubble(ui:UIComponent, width:Number, height:Number, caption:CaptionVO, oldStyle:Boolean=true, selected:Boolean = false, hovered:Boolean = false):Object {
			var tempValue:Number;
			var bubbleDetails:Object = getBubbleDetails(caption, width, height);
			var point:Point = bubbleDetails.point;
			var rectangle:Rectangle = bubbleDetails.rectangle;
			
			var borderColor:uint;
			var bottomColor:uint;
			var topColor:uint;
			if (hovered) {
				borderColor=HOVER_BORDER_COLOR;
				bottomColor=HOVER_BODY_COLOR;
				topColor=HOVER_BODY_COLOR
			} else if (oldStyle) {
				borderColor=OLD_CAPTION_BORDER_COLOR;
				bottomColor=OLD_CAPTION_COLOR_BOTTOM;
				topColor=OLD_CAPTION_COLOR_TOP;
			} else {
				borderColor=CAPTION_BORDER_COLOR;
				bottomColor=CAPTION_COLOR_BOTTOM;
				topColor=CAPTION_COLOR_TOP;
			}

			var matrix:Matrix=new Matrix();
			matrix.createGradientBox(width, height, 90 * Math.PI / 180, 0, 0);

			ui.graphics.clear();
			if (selected) {
				ui.graphics.beginFill(0, .01);
				ui.graphics.drawRect(0, 0, ui.width, ui.height);
				ui.graphics.endFill();
			}
			ui.graphics.lineStyle(2, borderColor, 1, true);
			ui.graphics.beginGradientFill(GradientType.LINEAR, [topColor, bottomColor], [1, 1], [1, 0xFF], matrix);

			SpeechBubble.drawSpeechBubble(ui, rectangle, 13, point);

			ui.graphics.endFill();
			return bubbleDetails;
		}

		public static function positionChildren(stageCaption:StageCaption):void {
			var caption:CaptionVO=stageCaption.model as CaptionVO;
			switch (caption.pointPosition.ordinal) {
				case EnumPosition.BOTTOM_LEFT.ordinal:
				case EnumPosition.BOTTOM_RIGHT.ordinal:
					stageCaption.captionMenuLayer.x = 0.0;
					stageCaption.captionMenuLayer.y = 0.0;
					stageCaption.captionMenuLayer.width = stageCaption.width;
					stageCaption.captionMenuLayer.height = stageCaption.height * .8;
					stageCaption.textEditorContainer.x=15.0;
					stageCaption.textEditorContainer.y=15.0;
					stageCaption.textEditorContainer.width=stageCaption.width - 30.0;
					stageCaption.textEditorContainer.height=stageCaption.height * .8 - 30.0;
					break;
				case EnumPosition.LEFT_BOTTOM.ordinal:
				case EnumPosition.LEFT_TOP.ordinal:
					stageCaption.captionMenuLayer.x = stageCaption.width * .2;
					stageCaption.captionMenuLayer.y = 0.0;
					stageCaption.captionMenuLayer.width = stageCaption.width * .8;
					stageCaption.captionMenuLayer.height = stageCaption.height;
					stageCaption.textEditorContainer.x=stageCaption.width * .2 + 15.0;
					stageCaption.textEditorContainer.y=15.0;
					stageCaption.textEditorContainer.width=stageCaption.width * .8 - 30.0;
					stageCaption.textEditorContainer.height=stageCaption.height - 30.0;
					break;
				case EnumPosition.TOP_LEFT.ordinal:
				case EnumPosition.TOP_RIGHT.ordinal:
					stageCaption.captionMenuLayer.x = 0.0;
					stageCaption.captionMenuLayer.y = stageCaption.height * .2;
					stageCaption.captionMenuLayer.width = stageCaption.width;
					stageCaption.captionMenuLayer.height = stageCaption.height * .8;
					stageCaption.textEditorContainer.x=15.0;
					stageCaption.textEditorContainer.y=stageCaption.height * .2 + 15.0;
					stageCaption.textEditorContainer.width=stageCaption.width - 30.0;
					stageCaption.textEditorContainer.height=stageCaption.height * .8 - 30.0;
					break;
				case EnumPosition.RIGHT_TOP.ordinal:
				case EnumPosition.RIGHT_BOTTOM.ordinal:
					stageCaption.captionMenuLayer.x = 0.0;
					stageCaption.captionMenuLayer.y = 0.0;
					stageCaption.captionMenuLayer.width = stageCaption.width * .8;;
					stageCaption.captionMenuLayer.height = stageCaption.height;
					stageCaption.textEditorContainer.x=15.0;
					stageCaption.textEditorContainer.y=15.0;
					stageCaption.textEditorContainer.width=stageCaption.width * .8 - 30.0;
					stageCaption.textEditorContainer.height=stageCaption.height - 30.0;
					break;
				case EnumPosition.NONE.ordinal:
					stageCaption.captionMenuLayer.x = 0.0;
					stageCaption.captionMenuLayer.y = 0.0;
					stageCaption.captionMenuLayer.width = stageCaption.width;
					stageCaption.captionMenuLayer.height = stageCaption.height;
					stageCaption.textEditorContainer.x=15.0;
					stageCaption.textEditorContainer.y=15.0;
					stageCaption.textEditorContainer.width=stageCaption.width - 30.0;
					stageCaption.textEditorContainer.height=stageCaption.height - 30.0;
					break;
			}
		}

		public static function getCaptionAdjustWidth(stageCaption:StageCaption):Number {
			return stageCaption.textEditor.measuredWidth - stageCaption.textEditorContainer.width;
		}

		public static function getCaptionAdjustHeight(stageCaption:StageCaption):Number {
			return stageCaption.textEditor.measuredHeight - stageCaption.textEditorContainer.height;
		}

		public static function getCaptionTotalWidth(captionVO:CaptionVO):Number {
			var result:Number=captionVO.width;
			if (captionVO.pointPosition.equals(EnumPosition.LEFT_BOTTOM) || captionVO.pointPosition.equals(EnumPosition.LEFT_TOP) || captionVO.pointPosition.equals(EnumPosition.RIGHT_BOTTOM) || captionVO.pointPosition.equals(EnumPosition.RIGHT_TOP)) {
				result+=captionVO.pointLength;
			}
			return result;
		}

		public static function getCaptionTotalHeight(captionVO:CaptionVO):Number {
			var result:Number=captionVO.height;
			if (captionVO.pointPosition.equals(EnumPosition.TOP_LEFT) || captionVO.pointPosition.equals(EnumPosition.TOP_RIGHT) || captionVO.pointPosition.equals(EnumPosition.BOTTOM_LEFT) || captionVO.pointPosition.equals(EnumPosition.BOTTOM_RIGHT)) {
				result+=captionVO.pointLength;
			}
			return result;
		}

		public static function getDragPosition(c:StageCaption):EnumPosition {
			var position:int=0;
			if (c.mouseY < 0) { //top_
				if (c.mouseX < c.width / 2) { //left
					position=1;
				} else { //right
					position=2;
				}
			} else if (c.mouseY > c.height) { //bottom_
				if (c.mouseX < c.width / 2) { //left
					position=3;
				} else { //right
					position=4;
				}
			} else if (c.mouseX < 0) { //left_
				if (c.mouseY < c.height / 2) { //top
					position=5;
				} else { //bottom
					position=6;
				}
			} else if (c.mouseX > c.width) { //right
				if (c.mouseY < c.height / 2) { //top
					position=7;
				} else { //bottom
					position=8;
				}
			}
			return new EnumPosition(position);
		}
		
		private static function drawLine(g:Graphics, start:Point, end:Point, 
										dashed:Boolean = false, dashLength:Number = 10):void {
			
			g.moveTo(start.x, start.y);
			if (dashed) {
				// the distance between the two points
				var total:Number = Point.distance(start, end);
				// divide the distance into segments
				if (total <= dashLength) {
					// just draw a solid line since the dashes won't show up
					g.lineTo(end.x, end.y);
				} else {
					// divide the line into segments of length dashLength 
					var step:Number = dashLength / total;
					var dashOn:Boolean = false;
					var p:Point;
					for (var t:Number = step; t <= 1; t += step) {
						p = getLinearValue(t, start, end);
						dashOn = !dashOn;
						if (dashOn) {
							g.lineTo(p.x, p.y);
						} else {
							g.moveTo(p.x, p.y);
						}
					}
					// finish the line if necessary
					dashOn = !dashOn;
					if (dashOn && !end.equals(p)) {
						g.lineTo(end.x, end.y);
					}
				}
			} else {
				// use the built-in lineTo function
				g.lineTo(end.x, end.y);
			}
		}
		
		public static function parseDisplay(string:String):EnumDisplay {
			var result:EnumDisplay = EnumDisplay.BEFORE;
			if (string) {
				if (string.toUpperCase() == "FALSE") {
					result = EnumDisplay.AFTER;
				} else if (string.toUpperCase() != "TRUE") {
					result = new EnumDisplay(parseInt(string));
				}
			}
			return result;
		}
		
		private static function getLinearValue(t:Number, start:Point, end:Point):Point {
			t = Math.max(Math.min(t, 1), 0);
			var x:Number = start.x + (t * (end.x - start.x));
			var y:Number = start.y + (t * (end.y - start.y));
			return new Point(x, y);    
		}
	}
}