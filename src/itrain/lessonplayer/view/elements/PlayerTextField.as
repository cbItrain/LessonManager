package itrain.lessonplayer.view.elements
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import itrain.common.model.vo.TextFieldVO;
	
	import mx.controls.TextInput;

	public class PlayerTextField extends TextInput
	{
		private var _timer:Timer;
		private var _newText:String;
		private var _endHandler:Function;
		
		public var modelReference:Object;

		public function PlayerTextField(t:TextFieldVO=null)
		{
			if (t)
			{
				this.displayAsPassword=t.password;
				this.htmlText=t.startText;
				this.height=t.height;
				this.width=t.width;
				this.x=t.x;
				this.y=t.y;
			}
			modelReference = t;
			this.setStyle("borderStyle", "none");
		}

		public function changeTextWithAnimation(newText:String, endHandler:Function=null, letterHoldDuration:int=300):void
		{
			_endHandler=endHandler;
			if (letterHoldDuration > 0 && newText != text)
			{
				if (_timer)
				{
					_timer.stop();
					_timer.removeEventListener(TimerEvent.TIMER, onTimerEvent);
				}
				_newText=newText;
				_timer=new Timer(letterHoldDuration);
				_timer.addEventListener(TimerEvent.TIMER, onTimerEvent);
				_timer.start();
			}
			else
			{
				this.text=newText;
				callEndHandler();
			}
		}
		
		public function isCorrect():Boolean {
			if (modelReference.caseSensitive)
				return modelReference.targetText == text;
			else
				return modelReference.targetText.toUpperCase() == text.toUpperCase();
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
				text=text.substring(0, text.length - 1);
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
				text+=_newText.charAt(text.length);
			}
		}
		
		public function isOver(point:Point):Boolean {
			var ltglobal:Point = new Point(x,y);
			var rbglobal:Point = new Point(ltglobal.x + width, ltglobal.y + height);
			return point.x >= ltglobal.x && point.x <= rbglobal.x && point.y >= ltglobal.y && point.y <= rbglobal.y;
		}
	}
}