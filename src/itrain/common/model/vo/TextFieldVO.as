package itrain.common.model.vo
{
	import flashx.textLayout.tlf_internal;
	
	import itrain.common.utils.DataUtils;
	
	import mx.utils.ObjectProxy;

	[RemoteClass]
	public class TextFieldVO extends SlideObjectVO
	{
		[Bindable]
		public var caseSensitive:Boolean;
		[Bindable]
		public var password:Boolean;
		[Bindable]
		public var startText:String;
		[Bindable]
		public var targetText:String;
		[Bindable]
		public var backgroundAlpha:Number=1.0;
		[Bindable]
		public var backgroundColor:uint;
		[Bindable]
		public var validateOnHotspot:Boolean=true;
		[Bindable]
		public var validateOnEnter:Boolean=true;

		public function TextFieldVO()
		{
			super();

			unlistenForChange();

			this.width=150.0;
			this.height=40.0;
			this.startText="";
			this.targetText="";
			this.backgroundColor=0xFFFFFF;

			listenForChange();
		}

		public function convertToXML():XML
		{
			var textfieldTag:XML=<textfield></textfield>;

			appendToXML(textfieldTag);
			if (caseSensitive)
				textfieldTag.appendChild(XMLList("<caseSensitive>" + caseSensitive + "</caseSensitive>"));
			if (password)
				textfieldTag.appendChild(XMLList("<password>" + password + "</password>"));
			textfieldTag.appendChild(XMLList("<startText><![CDATA[" + startText + "]]></startText>"));
			textfieldTag.appendChild(XMLList("<targetText><![CDATA[" + targetText + "]]></targetText>"));
			textfieldTag.appendChild(XMLList("<backgroundAlpha>" + backgroundAlpha + "</backgroundAlpha>"));
			textfieldTag.appendChild(XMLList("<backgroundColor>" + backgroundColor + "</backgroundColor>"));
			if (validateOnHotspot)
				textfieldTag.appendChild(XMLList("<validateOnHotspot>" + validateOnHotspot + "</validateOnHotspot>"));
			if (validateOnEnter)
				textfieldTag.appendChild(XMLList("<validateOnEnter>" + validateOnEnter + "</validateOnEnter>"));

			return textfieldTag;
		}
		
		override public function convertToXMLString():String {
			var textfieldTag:String = "<textfield>";
			
			textfieldTag += super.convertToXMLString();
			if (caseSensitive)
				textfieldTag += "<caseSensitive>" + caseSensitive + "</caseSensitive>";
			if (password)
				textfieldTag += "<password>" + password + "</password>";
			textfieldTag += "<startText><![CDATA[" + startText + "]]></startText>";
			textfieldTag += "<targetText><![CDATA[" + targetText + "]]></targetText>";
			textfieldTag += "<backgroundAlpha>" + backgroundAlpha + "</backgroundAlpha>";
			textfieldTag += "<backgroundColor>" + backgroundColor + "</backgroundColor>";
			if (validateOnHotspot)
				textfieldTag += "<validateOnHotspot>" + validateOnHotspot + "</validateOnHotspot>";
			if (validateOnEnter)
				textfieldTag += "<validateOnEnter>" + validateOnEnter + "</validateOnEnter>";
			textfieldTag += "</textfield>";
			return textfieldTag;
		}

		override public function clone():SlideObjectVO
		{
			var resultVO:TextFieldVO=new TextFieldVO();

			resultVO.unlistenForChange();

			copyTo(resultVO);
			resultVO.caseSensitive=caseSensitive;
			resultVO.password=password;
			resultVO.startText=startText;
			resultVO.targetText=targetText;
			resultVO.backgroundAlpha=backgroundAlpha;
			resultVO.backgroundColor=backgroundColor;
			resultVO.validateOnHotspot=validateOnHotspot;
			resultVO.validateOnEnter=validateOnEnter;

			resultVO.listenForChange();

			return resultVO;
		}

		override protected function parseObjectProxy(op:ObjectProxy):void
		{
			super.parseObjectProxy(op);

			unlistenForChange();

			this.caseSensitive=DataUtils.parseBoolean(op.caseSensitive);
			this.password=DataUtils.parseBoolean(op.password);
			this.startText=(op.startText) ? op.startText : "";
			this.targetText=(op.targetText) ? op.targetText : "";
			this.backgroundAlpha=op.backgroundAlpha;
			this.backgroundColor=(op.backgroundColor == null || isNaN(op.backgroundColor)) ? op.backgroundColor : 0xFFFFFF;
			this.validateOnHotspot=DataUtils.parseBoolean(op.validateOnHotspot);
			this.validateOnEnter=DataUtils.parseBoolean(op.validateOnEnter);

			listenForChange();
		}

		public static function newInstanceFromProxy(op:ObjectProxy):TextFieldVO
		{
			var result:TextFieldVO=new TextFieldVO();
			result.parseObjectProxy(op);
			return result;
		}
	}
}
