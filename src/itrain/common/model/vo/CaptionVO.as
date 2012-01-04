package itrain.common.model.vo
{
	import itrain.common.model.enum.EnumDisplay;
	import itrain.common.model.enum.EnumPosition;
	import itrain.common.utils.DataUtils;
	import itrain.common.utils.PositionUtils;
	import itrain.lessoneditor.utils.CaptionUtils;
	
	import mx.utils.ObjectProxy;
	
	[RemoteClass]
	public class CaptionVO extends SlideObjectVO
	{
		[Bindable] public var cornerSize:int;
		[Bindable] public var display:EnumDisplay;
		[Bindable] public var pointBase:int;
		[Bindable] public var pointIndent:int;
		[Bindable] public var pointLength:int;
		[Bindable] public var pointPosition:EnumPosition;
		[Bindable] public var text:String;
		[Bindable] public var hidable:Boolean;
		[Bindable] public var movable:Boolean;
		[Bindable] public var showContinue:Boolean;
		
		public var adjustable:Boolean;
		
		public function CaptionVO() {
			super();
			
			unlistenForChange();
			
			this.width = 200.0;
			this.height = 200.0;
			this.pointPosition = EnumPosition.LEFT_TOP;
			this.display = EnumDisplay.BEFORE;
			this.adjustable = false;
			this.hidable = false;
			this.movable = false;
			this.showContinue = false;
			
			listenForChange();
		}
		
		override public function clone():SlideObjectVO {
			var resultVO:CaptionVO = new CaptionVO();
			
			resultVO.unlistenForChange();
			
			copyTo(resultVO);
			resultVO.cornerSize = cornerSize;
			resultVO.display = display;
			resultVO.pointBase = pointBase;
			resultVO.pointIndent = pointIndent;
			resultVO.pointLength = pointLength;
			resultVO.pointPosition = pointPosition;
			resultVO.text = text;
			
			resultVO.listenForChange();
			
			return resultVO;
		}
		
		public function convertToXML():XML {
			var captionTag:XML = <caption></caption>;
			
			appendToXML(captionTag);
			captionTag.appendChild(XMLList("<cornerSize>" + cornerSize + "</cornerSize>"));
			captionTag.appendChild(XMLList("<display>" + display.ordinal + "</display>"));
			captionTag.appendChild(XMLList("<pointBase>" + pointBase + "</pointBase>"));
			captionTag.appendChild(XMLList("<pointIndent>" + pointIndent + "</pointIndent>"));
			captionTag.appendChild(XMLList("<pointLength>" + pointLength + "</pointLength>"));
			captionTag.appendChild(XMLList("<pointPosition>" + pointPosition.ordinal + "</pointPosition>"));
			captionTag.appendChild(XMLList("<text><![CDATA[" + text + "]]></text>"));
			captionTag.appendChild(XMLList("<hidable>" + hidable + "</hidable>"));
			captionTag.appendChild(XMLList("<movable>" + movable + "</movable>"));
			captionTag.appendChild(XMLList("<showContinue>" + showContinue + "</showContinue>"));
			
			return captionTag;
		}
		
		override protected function parseObjectProxy(op:ObjectProxy):void {
			super.parseObjectProxy(op);
			
			unlistenForChange();
			
			this.cornerSize = op.cornerSize;
			this.display = CaptionUtils.parseDisplay(op.display);
			this.pointBase = op.pointBase;
			this.pointIndent = op.pointIndent;
			this.pointLength = op.pointLength;
			this.pointPosition = PositionUtils.getPointPosition(op.pointPosition);
			
			this.hidable = DataUtils.parseBoolean(op.hidable);
			this.movable = DataUtils.parseBoolean(op.movable);
			this.showContinue = DataUtils.parseBoolean(op.showContinue);
			
			if (isNaN(this.width) || isNaN(this.height)) {//previous version compatibility
				this.adjustable = true;
				this.width = op.bodyWidth;
				this.height = op.bodyHeight;
				this.width = CaptionUtils.getCaptionTotalWidth(this);
				this.height = CaptionUtils.getCaptionTotalHeight(this);
				if (this.pointPosition.equals(EnumPosition.TOP_LEFT) || this.pointPosition.equals(EnumPosition.TOP_RIGHT)) {
					this.y -= this.pointLength;
				} else if (this.pointPosition.equals(EnumPosition.LEFT_TOP) || this.pointPosition.equals(EnumPosition.LEFT_BOTTOM)) {
					this.x -= this.pointLength;
				}
			}
			
			var tempString:String = op.text;
			if (tempString.indexOf("<![CDATA[") > -1) {
				this.text = tempString.substring(9,tempString.indexOf("]]>"));
			} else {
				this.text = tempString;
			}
			listenForChange();
		}
		
		public static function newInstanceFromProxy(op:ObjectProxy):CaptionVO {
			var result:CaptionVO = new CaptionVO();
			result.parseObjectProxy(op);
			return result;
		}
		
		public function adjustSize(width:Number, height:Number):void {
			unlistenForChange();
			
			this.width += width;
			this.height += height;
			
			listenForChange();
		}
	}
}