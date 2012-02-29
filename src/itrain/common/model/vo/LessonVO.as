package itrain.common.model.vo {
	import itrain.common.model.SlideCollectionAware;
	import itrain.common.utils.DataUtils;
	import itrain.lessoneditor.model.CaptureVO;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.utils.ObjectProxy;

	[Bindable]
	public class LessonVO extends SlideCollectionAware {
		public var notes:String;
		public var mouseSpeed:int;
		public var oldCaptionStyle:Boolean=false;
		public var showActionIndicator:Boolean=true;
		public var textSpeed:int; // to do
		public var captionSpeed:int; // to do
		public var themeColor:uint;
		public var controlsPosition:String;

		public function LessonVO() {
			super();

			unlistenForChange();

			listenForChange();
		}

		public function parseObjectProxy(op:ObjectProxy):void {
			if (op) {
				var properties:ObjectProxy=op.properties;

				this.unlistenForChange();
				
				this.oldCaptionStyle=!(op.version);
				if (!this.oldCaptionStyle)
					this.oldCaptionStyle=DataUtils.parseBoolean(properties.oldCaptions);
				this.showActionIndicator=DataUtils.parseBoolean(properties.actionIndicator);
				
				this.notes=properties.notes;
				this.mouseSpeed=properties.mouseSpeed;
				this.themeColor=properties.themeColor;
				this.controlsPosition=properties.controlsPosition;
				
				if (op.slides) {
					if (op.slides.slide is IList) {
						for each (var s:ObjectProxy in op.slides.slide) {
							slides.addItem(SlideVO.newInstanceFromProxy(s));
						}
					} else {
						slides.addItem(SlideVO.newInstanceFromProxy(op.slides.slide));
					}
				}

				this.listenForChange();
			}
		}

		public static function newInstanceFromProxy(op:ObjectProxy):LessonVO {
			var result:LessonVO;
			if (op) {
				result=new LessonVO();
				result.parseObjectProxy(op);
			}
			return result;
		}

		public function convertToXML():XML {
			var lessonTag:XML=<lesson version="1"></lesson>;
			var propertiesTag:XML=<properties></properties>;

			propertiesTag.appendChild(XMLList("<oldCaptions>" + oldCaptionStyle + "</oldCaptions>"));
			propertiesTag.appendChild(XMLList("<actionIndicator>" + showActionIndicator + "</actionIndicator>"));
			propertiesTag.appendChild(XMLList("<mouseSpeed>" + mouseSpeed + "</mouseSpeed>"));
			propertiesTag.appendChild(XMLList("<themeColor>" + themeColor + "</themeColor>"));
			propertiesTag.appendChild(XMLList("<controlsPosition>" + controlsPosition + "</controlsPosition>"));
			propertiesTag.appendChild(XMLList("<notes>" + notes + "</notes>"));

			lessonTag.appendChild(propertiesTag);

			var slidesTag:XML=<slides></slides>;
			for each (var s:SlideVO in slides) {
				slidesTag.appendChild(s.convertToXML());
			}

			lessonTag.appendChild(slidesTag);

			return lessonTag;
		}
		
		public function convertToXMLString():String {
			var lessonTag:String='<lesson version="1">';
			lessonTag += "<properties>";
			lessonTag += "<oldCaptions>" + oldCaptionStyle + "</oldCaptions>";
			lessonTag += "<actionIndicator>" + showActionIndicator + "</actionIndicator>";
			lessonTag += "<mouseSpeed>" + mouseSpeed + "</mouseSpeed>";
			lessonTag += "<themeColor>" + themeColor + "</themeColor>";
			lessonTag += "<controlsPosition>" + controlsPosition + "</controlsPosition>";
			lessonTag += "<notes>" + notes + "</notes>";
			lessonTag += "</properties>"
			lessonTag += "<slides>";
			for each (var s:SlideVO in slides) {
				lessonTag += s.convertToXMLString();
			}
			lessonTag += "</slides>";
			lessonTag += "</lesson>";
			return lessonTag;
		}
	}
}



