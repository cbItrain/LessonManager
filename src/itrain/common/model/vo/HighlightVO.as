package itrain.common.model.vo
{
	import itrain.common.model.enum.EnumAction;
	import itrain.common.model.enum.EnumCursor;
	import itrain.common.utils.ActionUtils;
	import itrain.common.utils.CursorUtils;
	import itrain.common.utils.DataUtils;

	import mx.utils.ObjectProxy;

	[RemoteClass]
	public class HighlightVO extends SlideObjectVO
	{

		[Bindable]
		public var borderColor:uint;
		[Bindable]
		public var borderWidth:int;
		[Bindable]
		public var borderAlpha:Number;
		[Bindable]
		public var cornerRadius:int;
		[Bindable]
		public var fillColor:uint;
		[Bindable]
		public var fillAlpha:Number;
		[Bindable]
		public var animationSpeed:int;
		[Bindable]
		public var watchItVisible:Boolean;
		[Bindable]
		public var tryItVisible:Boolean;

		public function HighlightVO()
		{
			super();

			unlistenForChange();

			this.width=150.0;
			this.height=40.0;

			borderColor=0xFFFF00;
			borderWidth=0;
			borderAlpha=1.0;
			fillColor=0XFFFF00;
			fillAlpha=.4;
			animationSpeed=0;
			cornerRadius=0.0;
			watchItVisible=true;
			tryItVisible=false;

			listenForChange();
		}

		override public function clone():SlideObjectVO
		{
			var resultVO:HighlightVO=new HighlightVO();

			resultVO.unlistenForChange();

			copyTo(resultVO);

			resultVO.borderWidth=this.borderWidth;
			resultVO.borderColor=this.borderColor;
			resultVO.borderAlpha=this.borderAlpha;
			resultVO.fillAlpha=this.fillAlpha;
			resultVO.fillColor=this.fillColor;
			resultVO.animationSpeed=this.animationSpeed;
			resultVO.cornerRadius=this.cornerRadius;
			resultVO.tryItVisible=this.tryItVisible;
			resultVO.watchItVisible=this.watchItVisible;

			resultVO.listenForChange();

			return resultVO;
		}

		override protected function parseObjectProxy(op:ObjectProxy):void
		{
			super.parseObjectProxy(op);

			unlistenForChange();

			this.borderWidth=op.borderWidth;
			this.borderColor=op.borderColor;
			this.borderAlpha=op.borderAlpha;
			this.fillAlpha=op.fillAlpha;
			this.fillColor=op.fillColor;
			this.animationSpeed=op.animationSpeed;
			this.cornerRadius=op.cornerRadius;
			this.tryItVisible=DataUtils.parseBoolean(op.tryItVisible);
			this.watchItVisible=DataUtils.parseBoolean(op.watchItVisible);

			listenForChange();
		}

		public function convertToXML():XML
		{
			var hotspotTag:XML=<highlight></highlight>;

			appendToXML(hotspotTag);
			if (tryItVisible)
				hotspotTag.appendChild(XMLList("<tryItVisible>" + tryItVisible + "</tryItVisible>"));
			if (watchItVisible)
				hotspotTag.appendChild(XMLList("<watchItVisible>" + watchItVisible + "</watchItVisible>"));
			hotspotTag.appendChild(XMLList("<cornerRadius>" + cornerRadius + "</cornerRadius>"));
			hotspotTag.appendChild(XMLList("<borderColor>" + borderColor + "</borderColor>"));
			hotspotTag.appendChild(XMLList("<borderWidth>" + borderWidth + "</borderWidth>"));
			hotspotTag.appendChild(XMLList("<borderAlpha>" + borderAlpha + "</borderAlpha>"));
			hotspotTag.appendChild(XMLList("<fillColor>" + fillColor + "</fillColor>"));
			hotspotTag.appendChild(XMLList("<fillAlpha>" + fillAlpha + "</fillAlpha>"));
			hotspotTag.appendChild(XMLList("<animationSpeed>" + animationSpeed + "</animationSpeed>"));

			return hotspotTag;
		}

		public static function newInstanceFromProxy(op:ObjectProxy):HighlightVO
		{
			var result:HighlightVO=new HighlightVO();
			result.parseObjectProxy(op);
			return result;
		}
	}
}
