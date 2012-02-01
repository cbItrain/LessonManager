package itrain.common.model.vo {
	import flash.events.EventDispatcher;
	
	import itrain.common.utils.DataUtils;
	import itrain.lessoneditor.model.SlideCaptureVO;
	
	import mx.collections.IList;
	import mx.controls.Image;
	import mx.utils.ObjectProxy;

	[Bindable]
	[RemoteClass]
	public class SlideVO extends ChangeAwareModel {
		//public var title:String;
		public var source:String;
		//public var thumb:String;
		public var interText:String;
		public var hotspots:Array;
		public var captions:Array;
		public var textfields:Array;
		public var highlights:Array;
		public var start:int;
		public var end:int;
		//public var cursor:String;
		//public var validation:Boolean;
		//public var result:String;
		public var instructionTopPos:Boolean;

		public function SlideVO() {
			super();
			
			unlistenForChange();
			
			instructionTopPos = true;
			//title="Untitled";
			hotspots=[];
			captions=[];
			textfields=[];
			highlights=[];
			start = 1.0;
			end = 1.0;
			
			listenForChange();
		}
		
		public function convertToXML():XML {
			var slideTag:XML = <slide></slide>;
			
			//slideTag.appendChild(XMLList("<cursor>" + cursor + "</cursor>"));
			slideTag.appendChild(XMLList("<start>" + start + "</start>"));
			slideTag.appendChild(XMLList("<end>" + end + "</end>"));
			//slideTag.appendChild(XMLList("<title>" + title + "</title>"));
			slideTag.appendChild(XMLList("<source>" + source + "</source>"));
			//slideTag.appendChild(XMLList("<thumb>" + thumb + "</thumb>"));
			slideTag.appendChild(XMLList("<interText><![CDATA[" + (interText ? interText : "") + "]]></interText>"));
			if (instructionTopPos)
				slideTag.appendChild(XMLList("<instructionTopPos>" + instructionTopPos + "</instructionTopPos>"));
			//slideTag.appendChild(XMLList("<validation>" + validation + "</validation>"));
			
			var captionsTag:XML = <captions></captions>;
			
			for each (var c:CaptionVO in captions) {
				captionsTag.appendChild(c.convertToXML());
			}
			
			slideTag.appendChild(captionsTag);
			
			var hotspotsTag:XML = <hotspots></hotspots>;
			
			for each (var ho:HotspotVO in hotspots) {
				hotspotsTag.appendChild(ho.convertToXML());
			}
			
			slideTag.appendChild(hotspotsTag);
			
			var textfieldsTag:XML = <textfields></textfields>;
			
			for each (var t:TextFieldVO in textfields) {
				textfieldsTag.appendChild(t.convertToXML());
			}
			
			slideTag.appendChild(textfieldsTag);
			
			var highlightsTag:XML = <highlights></highlights>;
			
			for each (var hi:HighlightVO in highlights) {
				highlightsTag.appendChild(hi.convertToXML());
			}
			
			slideTag.appendChild(highlightsTag);
			
			return slideTag;
		}
		
		public function clone():SlideVO {
			var resultVO:SlideVO = new SlideVO();		
			
			resultVO.unlistenForChange();
			
			//resultVO.title = title;
			resultVO.source = source;
			//resultVO.thumb = thumb;
			resultVO.interText = interText;
			resultVO.start = start;
			resultVO.end = end;
			//resultVO.cursor = cursor;
			//resultVO.validation = validation;
			//resultVO.result = result;
			resultVO.instructionTopPos = instructionTopPos;
			for each (var ho:HotspotVO in hotspots) {
				resultVO.hotspots.push(ho.clone());
			}
			for each (var c:CaptionVO in captions) {
				resultVO.captions.push(c.clone());
			}
			for each (var t:TextFieldVO in textfields) {
				resultVO.textfields.push(t.clone());
			}
			for each (var hi:HighlightVO in highlights) {
				resultVO.highlights.push(hi.clone());
			}
			resultVO.listenForChange();
			
			return resultVO;
		}

		public function parseObjectProxy(op:ObjectProxy):void {
			
			this.unlistenForChange();
			
			//this.title=op.title;
			this.source=op.source;
			//this.thumb=op.thumb;
			this.interText=DataUtils.cleanHTMLText(op.interText);
			this.start=op.start;
			this.end=op.end;
			//this.cursor=op.cursor;
			//this.validation=DataUtils.parseBoolean(op.validation);
			this.instructionTopPos=DataUtils.parseBoolean(op.instructionTopPos);

			if (op.captions) {
				if (op.captions.caption is IList) {
					for each (var c:ObjectProxy in op.captions.caption) {
						this.captions.push(CaptionVO.newInstanceFromProxy(c));
					}
				} else {
					this.captions.push(CaptionVO.newInstanceFromProxy(op.captions.caption));
				}
			}

			if (op.hotspots) {
				if (op.hotspots.hotspot is IList) {
					for each (var ho:ObjectProxy in op.hotspots.hotspot) {
						this.hotspots.push(HotspotVO.newInstanceFromProxy(ho));
					}
				} else {
					this.hotspots.push(HotspotVO.newInstanceFromProxy(op.hotspots.hotspot));
				}
			}

			if (op.textfields) {
				if (op.textfields.textfield is IList) {
					for each (var t:ObjectProxy in op.textfields.textfield) {
						this.textfields.push(TextFieldVO.newInstanceFromProxy(t));
					}
				} else {
					this.textfields.push(TextFieldVO.newInstanceFromProxy(op.textfields.textfield));
				}
			}
			
			if (op.highlights) {
				if (op.highlights.highlight is IList) {
					for each (var hi:ObjectProxy in op.highlights.highlight) {
						this.highlights.push(HighlightVO.newInstanceFromProxy(hi));
					}
				} else {
					this.highlights.push(HighlightVO.newInstanceFromProxy(op.highlights.highlight));
				}
			}
			
			listenForChange();
		}

		public static function newInstanceFromProxy(op:ObjectProxy):SlideVO {
			var result:SlideVO=new SlideVO();
			result.parseObjectProxy(op);
			return result;
		}
		
		public static function fromSlideCapture(value:SlideCaptureVO, sourceOnly:Boolean):SlideVO {
			var result:SlideVO = new SlideVO();
			
			result.unlistenForChange();
			
			result.source = value.source;
			
			if (!sourceOnly) {
				if (value.hotspot)
					result.hotspots.push(value.hotspot);
			}
			
			result.listenForChange();
			
			return result;
		}
		
		
		
	}
}



