package itrain.common.view.stageobjects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.IEditManager;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.TextFlow;
	
	import itrain.common.model.vo.SlideObjectVO;
	import itrain.common.model.vo.TextFieldVO;
	import itrain.common.utils.Embeded;
	import itrain.common.utils.ViewModelUtils;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Text;
	import mx.utils.StringUtil;
	
	import spark.components.TextArea;
	
	public class StageTextArea extends TextArea implements IStageObject
	{
		private static var MARKER_BITMAP_DATA:BitmapData = getMarkerBitmapData();
		private static var MARKER_COLOR:uint =0xFFD400;
		
		[Bindable]
		public var model:SlideObjectVO;
		
		private var _timer:Timer;
		private var _newText:String = "";
		private var _endHandler:Function;
		private var _editable:Boolean;
		private var _showMarker:Boolean = true;
		
		private static function getMarkerBitmapData():BitmapData {
			return ((new (Embeded.TEXT_AREA_STRIPE_BACKGROUND)()) as Bitmap).bitmapData;
		}
		
		public function stop():void {
			_endHandler = null;
			if (_timer && _timer.running)
				_timer.stop();
		}
		
		public function StageTextArea(model:SlideObjectVO, editable:Boolean = false)
		{
			super();
			this.model = model;
			ViewModelUtils.bindViewModel(this, model);
			
			this.setStyle("	focusSkin", null);
			this.setStyle("focusThickness", 0);
			this.setStyle("borderStyle", "solid");
			
			_editable = editable;
			
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			bindProperty();
		}
		
		private function bindProperty():void {
			BindingUtils.bindSetter(onStartTextChange, model, "startText");
			if (!_editable) {
				BindingUtils.bindSetter(onStartTextChange, model, "targetText");
			}
			BindingUtils.bindSetter(onPasswordChange, model, "password");
			BindingUtils.bindSetter(onBackgroundAlphaChange, model, "backgroundAlpha");
			BindingUtils.bindSetter(onBackgroundColorChange, model, "backgroundColor");
		}
		
		public function get showMarker():Boolean {
			return _showMarker;
		}
		
		public function set showMarker(value:Boolean):void {
			_showMarker = value;
			invalidateDisplayList();
		}
		
		private function onPasswordChange(value:Boolean):void {
			this.displayAsPassword = value;
			callLater(onStartTextChange);
		}
		
		private function onBackgroundAlphaChange(value:Number):void {
			this.setStyle("contentBackgroundAlpha", value);
		}
		
		private function onBackgroundColorChange(value:Number):void {
			this.setStyle("contentBackgroundColor", value);
		}
		
		private function onStartTextChange(value:String = null):void {
			var tfModel:TextFieldVO = model as TextFieldVO;
			var startFlow:TextFlow = TextConverter.importToFlow(tfModel.startText, TextConverter.TEXT_FIELD_HTML_FORMAT);
			var targetFlow:TextFlow = TextConverter.importToFlow(tfModel.targetText, TextConverter.TEXT_FIELD_HTML_FORMAT);
			var txt:String = startFlow.getText();
			if (_editable || startFlow.getText()) {
				textFlow = startFlow;
			} else {
				if (targetFlow.getText())
					textFlow = targetFlow;
				else
					textFlow = TextConverter.importToFlow("", TextConverter.TEXT_FIELD_HTML_FORMAT);
			}
		}
		
		public function isOver(point:Point):Boolean {
			var ltglobal:Point = new Point(x,y);
			var rbglobal:Point = new Point(ltglobal.x + width, ltglobal.y + height);
			return point.x >= ltglobal.x && point.x <= rbglobal.x && point.y >= ltglobal.y && point.y <= rbglobal.y;
		}
		
		public function changeTextWithAnimation(newText:String, endHandler:Function=null, letterHoldDuration:int=300):void
		{
			_endHandler=endHandler;
			var newTextFlow:TextFlow = TextConverter.importToFlow(newText, TextConverter.TEXT_FIELD_HTML_FORMAT);
			var cleanText:String = newTextFlow.getText();
			setFocus();
			selectRange(text.length, text.length);
			if (letterHoldDuration > 0 && cleanText != text)
			{
				if (_timer)
				{
					_timer.stop();
					_timer.removeEventListener(TimerEvent.TIMER, onTimerEvent);
				}
				_newText=cleanText;
				_timer=new Timer(letterHoldDuration);
				_timer.addEventListener(TimerEvent.TIMER, onTimerEvent);
				_timer.start();
			}
			else
			{
				(textFlow.interactionManager as IEditManager).insertText(_newText.charAt(text.length),new SelectionState(textFlow, 0, text.length));
				this.text=cleanText;
				callEndHandler();
			}
		}
		
		private function onMouseClick(me:MouseEvent):void {
			if (!editable && me.target != this) {
				me.stopImmediatePropagation();
				
				var newMe:MouseEvent = new MouseEvent(MouseEvent.CLICK, true, false);
				dispatchEvent(newMe);
			}
		}
		
		public function isCorrect():Boolean {
			var tfModel:TextFieldVO = model as TextFieldVO;
			var targetText:String = TextConverter.importToFlow(tfModel.targetText,TextConverter.TEXT_FIELD_HTML_FORMAT).getText();
			if (tfModel.caseSensitive)
				return StringUtil.trim(targetText) == StringUtil.trim(text);
			else
				return StringUtil.trim(targetText).toUpperCase() == StringUtil.trim(text).toUpperCase();
		}
		
		private function callEndHandler():void
		{
			if (_endHandler != null)
				_endHandler();
		}
		
		private function onTimerEvent(e:TimerEvent):void
		{
			if (_newText.indexOf(this.text) != 0)
			{
				(textFlow.interactionManager as IEditManager).deletePreviousCharacter();
			}
			else if (_newText.length == text.length)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, onTimerEvent);
				_timer=null;
				callEndHandler();
			}
			else
			{
				(textFlow.interactionManager as IEditManager).insertText(_newText.charAt(text.length));
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			graphics.clear();
			if (_showMarker) {
				this.setStyle("borderVisible", true);
				this.setStyle("borderColor", MARKER_COLOR);
				this.setStyle("borderThickness", 2);
				//setStyle("contentBackgroundAlpha", 0.0);
			} else {
				this.setStyle("borderVisible", !_editable);
				this.setStyle("borderColor", 0);
				this.setStyle("borderThickness", 1);
				//setStyle("contentBackgroundAlpha", textFieldVO.backgroundAlpha);
				setStyle("contentBackgroundColor", textFieldVO.backgroundColor);
			}
			setStyle("contentBackgroundAlpha", textFieldVO.backgroundAlpha);
		}
		
		public function get textFieldVO():TextFieldVO {
			return model as TextFieldVO;
		}
		
		private function onKeyDown(ke:KeyboardEvent):void {
			if (ke.keyCode == Keyboard.ENTER) {
				this.text = this.text.replace("\n", "");
				this.selectRange(this.text.length, this.text.length);
			}
		}
	}
}