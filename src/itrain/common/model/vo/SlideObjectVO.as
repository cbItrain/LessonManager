package itrain.common.model.vo {
	import com.objecthandles.IMoveable;
	import com.objecthandles.IResizeable;
	
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;
	import mx.events.PropertyChangeEvent;
	import mx.utils.ObjectProxy;

	[RemoteClass]
	public class SlideObjectVO extends ChangeAwareModel implements IMoveable, IResizeable {
		
		private var _width:int=0;
		private var _height:int=0;
		private var _x:int=0;
		private var _y:int=0;
		private var _rotation:int=0;

		public function SlideObjectVO() {
			super();
		}

		public function copyTo(so:SlideObjectVO):void {
			if (so) {
				so.x=x;
				so.y=y;
				so.width=width;
				so.height=height;
				so.rotation=rotation;
			}
		}

		public function clone():SlideObjectVO {
			var resultVO:SlideObjectVO=new SlideObjectVO();
			
			resultVO.unlistenForChange();
			
			resultVO.x=_x;
			resultVO.y=_y;
			resultVO.width=_width;
			resultVO.height=_height;
			resultVO.rotation=_rotation;
			
			resultVO.listenForChange();
			
			return resultVO;
		}
		
		public function convertToXMLString():String {
			var result:String = "";
			result += "<width>" + width + "</width>";
			result += "<height>" + height + "</height>";
			result += "<rotation>" + rotation + "</rotation>";
			result += "<x>" + x + "</x>";
			result += "<y>" + y + "</y>";
			return result;
		}

		protected function appendToXML(xml:XML):void {
			if (xml) {
				xml.appendChild(XMLList("<width>" + width + "</width>"));
				xml.appendChild(XMLList("<height>" + height + "</height>"));
				xml.appendChild(XMLList("<rotation>" + rotation + "</rotation>"));
				xml.appendChild(XMLList("<x>" + x + "</x>"));
				xml.appendChild(XMLList("<y>" + y + "</y>"));
			}
		}

		protected function parseObjectProxy(op:ObjectProxy):void {
			unlistenForChange();

			this.width=op.width;
			this.height=op.height;
			this.x=op.x;
			this.y=op.y;			
			
			listenForChange();
		}

		[Bindable]
		public function get width():Number {
			return _width;
		}

		public function set width(val:Number):void {
			_width=val;
		}

		[Bindable]
		public function get height():Number {
			return _height;
		}

		public function set height(val:Number):void {
			_height=val;
		}

		[Bindable]
		public function get x():Number {
			return _x;
		}

		public function set x(val:Number):void {
			_x=val;
		}

		[Bindable]
		public function get y():Number {
			return _y;
		}

		public function set y(val:Number):void {
			_y=val;
		}

		[Bindable]
		public function get rotation():Number {
			return _rotation;
		}

		public function set rotation(val:Number):void {
			_rotation=val;
		}
		
		//-----------------------------------------------------------------
	}
}