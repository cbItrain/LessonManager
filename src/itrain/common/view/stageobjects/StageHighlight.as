package itrain.common.view.stageobjects
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import itrain.common.model.vo.HighlightVO;
	import itrain.common.model.vo.SlideObjectVO;
	import itrain.common.utils.Common;
	import itrain.common.utils.ViewModelUtils;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.core.UIComponent;
	import mx.effects.Sequence;
	import mx.states.OverrideBase;
	
	import spark.effects.Fade;
	
	public class StageHighlight extends UIComponent implements IStageObject
	{
		private static const PREVIEW_INTERVAL:int = 2000;
		
		
		[Bindable]
		public var model:SlideObjectVO;
		
		private var _editable:Boolean;
		private var _flashingEffect:Sequence;
		private var _fadeIn:Fade;
		private var _fadeOut:Fade;
		private var _watchers:Vector.<ChangeWatcher>;
		
		public function StageHighlight(model:SlideObjectVO, editable:Boolean=true)
		{
			this.model = model;
			_editable = editable;
			_watchers = new Vector.<ChangeWatcher>();
			if (editable) {
				ViewModelUtils.bindViewModel(this, model, _watchers);
			} else {
				this.x = model.x;
				this.y = model.y;
				this.width = model.width;
				this.height = model.height;
				this.rotation = model.rotation;
			}
			
			createEffect();
			
			bindOtherProperties(_watchers);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function bindOtherProperties(watchers:Vector.<ChangeWatcher>):void {
			watchers.push(BindingUtils.bindSetter(onChange, model, "borderColor"));
			watchers.push(BindingUtils.bindSetter(onChange, model, "borderAlpha"));
			watchers.push(BindingUtils.bindSetter(onChange, model, "borderWidth"));
			watchers.push(BindingUtils.bindSetter(onChange, model, "fillColor"));
			watchers.push(BindingUtils.bindSetter(onChange, model, "fillAlpha"));
			watchers.push(BindingUtils.bindSetter(onChange, model, "cornerRadius"));
			if (_editable)
				watchers.push(BindingUtils.bindSetter(onAnimationSpeedChange, model, "animationSpeed"));
		}
		
		private function onRemovedFromStage(e:Event):void {
			ViewModelUtils.unbind(_watchers);
			
			_flashingEffect = null;
			_fadeIn = null;
			_fadeOut = null;
			model = null;
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage)
		}
		
		private function createEffect():void {
			_flashingEffect = new Sequence(this);
			
			_fadeOut = new Fade();
			_fadeOut.alphaFrom = 1.0;
			_fadeOut.alphaTo = 0.0;
			_flashingEffect.addChild(_fadeOut);
			_fadeIn = new Fade();
			_fadeIn.alphaFrom = 0.0;
			_fadeIn.alphaTo = 1.0;
			_flashingEffect.addChild(_fadeIn);
			
			_flashingEffect.repeatCount = 0;
		}
		
		override protected function childrenCreated():void {
			updateEffect();
		}
		
		private function updateEffect():void {
			if (_flashingEffect.isPlaying) {
				_flashingEffect.pause();
			}
			this.alpha = 1.0;
			if (highlightVO.animationSpeed != 0) {
				var duration:Number = 1000 / highlightVO.animationSpeed;
				_fadeOut.duration = .7 * duration;
				_fadeIn.duration = .3 * duration;
				_flashingEffect.repeatCount = _editable ? PREVIEW_INTERVAL / duration : 0;
				_flashingEffect.play();
			}
		}
		
		private function onAnimationSpeedChange(o:Object = null):void {
			updateEffect();
		}
		
		private function onChange(o:Object = null):void {
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var hModel:HighlightVO = model as HighlightVO;

			graphics.clear();
			graphics.lineStyle(hModel.borderWidth == 0 ? NaN : hModel.borderWidth, hModel.borderColor, hModel.borderAlpha);
			graphics.beginFill(hModel.fillColor, hModel.fillAlpha);
			graphics.drawRoundRectComplex(0, 0, unscaledWidth, unscaledHeight, hModel.cornerRadius, hModel.cornerRadius, hModel.cornerRadius, hModel.cornerRadius);
			graphics.endFill();
		}
		
		public function isOver(point:Point):Boolean {
			var ltglobal:Point = new Point(x,y);
			var rbglobal:Point = new Point(x + width, y + height);
			return point.x >= ltglobal.x && point.x <= rbglobal.x && point.y >= ltglobal.y && point.y <= rbglobal.y;
		}
		
		public function preview():void {
			updateEffect();
		}
		
		public function get highlightVO():HighlightVO {
			return model as HighlightVO;
		}
	}
}