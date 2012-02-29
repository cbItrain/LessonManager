package itrain.common.view.stageobjects {
	import com.adobe.linguistics.spelling.SpellUI;
	import com.adobe.linguistics.spelling.SpellUIForTLF;

	import flash.display.GradientType;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;

	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;

	import itrain.co.uk.components.InPlaceTextEditor;
	import itrain.co.uk.events.InPlaceTextEditorEvent;
	import itrain.common.events.CaptionEvent;
	import itrain.common.model.enum.EnumPosition;
	import itrain.common.model.vo.CaptionVO;
	import itrain.common.model.vo.SlideObjectVO;
	import itrain.common.utils.Common;
	import itrain.common.utils.Embeded;
	import itrain.common.utils.ViewModelUtils;
	import itrain.common.view.CaptionMenu;
	import itrain.common.view.DotedFrame;
	import itrain.lessoneditor.other.PointerHandle;
	import itrain.lessoneditor.utils.CaptionUtils;

	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;

	import spark.components.Group;
	import spark.components.RichEditableText;
	import spark.components.RichText;
	import spark.filters.DropShadowFilter;

	use namespace mx_internal;

	public class StageCaption extends Group implements IStageObject {
		[Bindable]
		public var model:SlideObjectVO;
		
		private var _dragCursor:Class=Embeded.CURSOR_MOVE;
		private var _editorCursor:Class=Embeded.TEXT_CURSOR;

		public var textEditor:InPlaceTextEditor;
		public var textEditorContainer:Group;
		public var captionMenuLayer:CaptionMenu;

		public var lastX:Number;
		public var lastY:Number;

		private var _pointPositionWatcher:ChangeWatcher;
		private var _textModelWatcher:ChangeWatcher;
		private var _editable:Boolean;
		private var _oldStyle:Boolean=false;

		private var _dottedFrame:DotedFrame;
		private var _pointerHandle:PointerHandle;
		private var _dragPositionHolder:EnumPosition;
		private var _dragCursorId:int;
		private var _editorCursorId:int=-1;
		private var _watchers:Vector.<ChangeWatcher>;

		private var _spellCheckEnabled:Boolean=false;

		public function StageCaption(model:SlideObjectVO, editable:Boolean=true, oldStyle:Boolean=false) {
			super();
			this.model=model;

			_oldStyle=oldStyle;
			_editable=editable;

			lastX=model.x;
			lastY=model.y;

			_watchers=new Vector.<ChangeWatcher>();
			if (editable) {
				ViewModelUtils.bindViewModel(this, model, _watchers);
				bindOtherProperties(_watchers);
				this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			} else {
				this.x=model.x;
				this.y=model.y;
				this.width=model.width;
				this.height=model.height;
				this.rotation=model.rotation;
			}

			this.filters=[Common.dropShadow];

			_pointPositionWatcher=ChangeWatcher.watch(model, "pointPosition", onPointPositionChange);
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		public function get isEditable():Boolean {
			return _editable;
		}

		public function get oldStyle():Boolean {
			return _oldStyle;
		}

		public function set pointerHandleVisible(value:Boolean):void {
			_pointerHandle.visible=value;
			_dottedFrame.visible=value;
			invalidateDisplayList();
		}

		public function set oldStyle(value:Boolean):void {
			_oldStyle=value;
			invalidateDisplayList();
		}

		private function onRemovedFromStage(e:Event):void {
			this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.removeEventListener(MouseEvent.CLICK, onMouseClick);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onDragMouseOut);
			this.removeEventListener(MouseEvent.MOUSE_OVER, onDragMouseOver);

			_watchers.push(_pointPositionWatcher);
			_watchers.push(_textModelWatcher);

			ViewModelUtils.unbind(_watchers);

			_pointPositionWatcher=null;
			_textModelWatcher=null;
			model=null;
			textEditor=null;
			textEditorContainer=null;
			captionMenuLayer=null;
			_dottedFrame=null;
			_pointerHandle=null;
			_dragPositionHolder=null;
			_dragCursor=null;
			_editorCursor=null;
			this.removeAllElements();
		}

		private function onMouseOver(me:MouseEvent):void {
			if (me.target == this)
				_editorCursorId=CursorManager.setCursor(_editorCursor, CursorManagerPriority.LOW, -8.0, -10);
		}

		private function onMouseOut(me:MouseEvent):void {
			if (me.target == this)
				CursorManager.removeCursor(_editorCursorId);
		}

		private function bindOtherProperties(watchers:Vector.<ChangeWatcher>):void {
			watchers.push(BindingUtils.bindSetter(onInteractionOptionsChange, model, "movable"));
			watchers.push(BindingUtils.bindSetter(onInteractionOptionsChange, model, "hidable"));
			watchers.push(BindingUtils.bindSetter(onInteractionOptionsChange, model, "showContinue"));
		}

		private function onInteractionOptionsChange(o:Object=null):void {
			if (captionMenuLayer) {
				captionMenuLayer.continueHandler=(captionVO.movable || captionVO.showContinue) ? continueClicked : null;
				captionMenuLayer.showHideHandler=captionVO.hidable ? showHideClicked : null;
			}
		}

		public function setPointerHandlePosition(point:Point):void {
			_pointerHandle.x=point.x;
			_pointerHandle.y=point.y;
		}

		private function onPointPositionChange(o:Object):void {
			this.invalidateDisplayList();
		}

		override protected function createChildren():void {
			super.createChildren();
			if (!captionMenuLayer) {
				captionMenuLayer=new CaptionMenu();
				captionMenuLayer.mouseEnabled=false;
				captionMenuLayer.mouseChildren=!_editable;
				if (captionVO.hidable) {
					captionMenuLayer.showHideHandler=showHideClicked;
				}
				if (captionVO.movable) {
					captionMenuLayer.continueHandler=continueClicked;
					if (!_editable) {
						this.addEventListener(MouseEvent.MOUSE_OUT, onDragMouseOut);
						this.addEventListener(MouseEvent.MOUSE_OVER, onDragMouseOver);
					}
				}
				if (captionVO.showContinue) {
					captionMenuLayer.continueHandler=continueClicked;
				}
				this.addElement(captionMenuLayer);
			}
			if (!textEditorContainer) {
				textEditorContainer=new Group();
				textEditorContainer.clipAndEnableScrolling=true;
				textEditorContainer.mouseEnabled=textEditorContainer.mouseChildren=_editable;
				this.addElement(textEditorContainer);
			}
			if (!textEditor) {
				textEditor=new InPlaceTextEditor(_editable, this);

				textEditor.percentWidth=100;
				textEditorContainer.addElement(textEditor);

				textEditor.mouseEnabled=textEditor.selectable=textEditor.editable=_editable;
				_textModelWatcher=ChangeWatcher.watch(model, "text", onModelTextChange);
				onModelTextChange((model as CaptionVO).text);

				if (_editable) {
					textEditor.addEventListener(InPlaceTextEditorEvent.DELETE_CLICKED, onDeleteItem);
					textEditor.addEventListener(InPlaceTextEditorEvent.TEXT_CHANGES, onTextChange);
					this.addEventListener(KeyboardEvent.KEY_DOWN, onTextEditorKeyDown, true);
				}
			}
			if (_editable) {
				if (!_dottedFrame) {
					_dottedFrame=new DotedFrame();
					_dottedFrame.visible=false;
					this.addElement(_dottedFrame);
				}
				if (!_pointerHandle) {
					_pointerHandle=new PointerHandle();
					_pointerHandle.visible=false;
					this.addElement(_pointerHandle);
				}
			}
		}

		private function onDragMouseOver(me:MouseEvent):void {
			if (me.currentTarget == me.target)
				_dragCursorId=CursorManager.setCursor(_dragCursor);
		}

		private function onDragMouseOut(me:MouseEvent):void {
			if (me.currentTarget == me.target)
				CursorManager.removeCursor(_dragCursorId);
		}

		private function showHideClicked():void {
			dispatchEvent(new CaptionEvent(CaptionEvent.MINIMIZE_CAPTION, true));
		}

		private function continueClicked():void {
			dispatchEvent(new CaptionEvent(CaptionEvent.CONTINUE, true));
		}

		private function onTextEditorKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.Z && e.ctrlKey) {
				e.stopImmediatePropagation();
				var ke:KeyboardEvent=new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, Keyboard.Z, 0, true);
				dispatchEvent(ke);
			}
		}

		private function onTextChange(e:Event = null):void {
			_textModelWatcher.unwatch();
			(model as CaptionVO).text=TextConverter.export(textEditor.textFlow, TextConverter.TEXT_FIELD_HTML_FORMAT, ConversionType.STRING_TYPE) as String;
			_textModelWatcher.reset(model);
		}

		private function onDeleteItem(e:Event):void {
			var ke:KeyboardEvent=new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 0, Keyboard.DELETE);
			dispatchEvent(ke);
		}

		public function disableSpelling():void {
			try {
				if (textEditor.textFlow && _spellCheckEnabled) {
					SpellUI.disableSpelling(textEditor);
					_spellCheckEnabled=false;
				}
			} catch (e:Error) {
				trace(e);
			}
		}

		public function enableSpelling():void {
			try {
				if (textEditor.textFlow && !_spellCheckEnabled) {
					textEditor.selectable=textEditor.editable=textEditor.focusEnabled=false;
					SpellUI.enableSpelling(textEditor, "en_US");
					_spellCheckEnabled=true;
					textEditor.selectable=textEditor.editable=textEditor.focusEnabled=true;
				}
			} catch (e:Error) {
				trace(e);
			}
		}

		private function onModelTextChange(o:Object):void {
			textEditor.textFlow=TextConverter.importToFlow((model as CaptionVO).text, TextConverter.TEXT_FIELD_HTML_FORMAT);
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			CaptionUtils.positionChildren(this);
			var point:Point=CaptionUtils.drawSpeachBubble(this, unscaledWidth, unscaledHeight, model as CaptionVO, _oldStyle, _pointerHandle == null ? false : _pointerHandle.visible).point as Point;

			if (_editable) {
				if (captionVO.pointPosition.equals(EnumPosition.NONE))
					this.setPointerHandlePosition(new Point(.8 * unscaledWidth, unscaledHeight));
				else
					this.setPointerHandlePosition(point);
			}

			if ((model as CaptionVO).adjustable && textEditor.width && textEditor.height) {
				captionVO.adjustable=false;
				captionVO.adjustSize(CaptionUtils.getCaptionAdjustWidth(this), CaptionUtils.getCaptionAdjustHeight(this));
			}
			if (_dottedFrame) {
				_dottedFrame.width=unscaledWidth;
				_dottedFrame.height=unscaledHeight;
			}
			//trace("Stage Caption Update");
			//trace("Caption width/height: " + textEditor.width + " " + textEditor.height + " measured width/height: " + textEditor.measuredWidth + " " + textEditor.measuredHeight);
		}

		private function onMouseClick(me:MouseEvent):void {
			if (_editable && me.target != this) {
				me.stopImmediatePropagation();
				var newMe:MouseEvent=new MouseEvent(MouseEvent.CLICK, true, false);
				dispatchEvent(newMe);
			}
		}

		override public function setFocus():void {
			super.setFocus();
			textEditor.setFocus();
		}

		public function isOver(point:Point):Boolean {
			var ltglobal:Point=new Point(x, y);
			var rbglobal:Point=new Point(x + width, y + height);
			return point.x >= ltglobal.x && point.x <= rbglobal.x && point.y >= ltglobal.y && point.y <= rbglobal.y;
		}

		private function onMouseDown(me:MouseEvent):void {
			if (_editable) {
				if (_dottedFrame.visible && textEditor.isFocused()) {
					me.preventDefault();
					me.stopImmediatePropagation();
				}
				if (me.target == _pointerHandle) {
					_dragPositionHolder=captionVO.pointPosition;
					captionVO.unlistenForChange();
					this.parentApplication.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, true);
					this.parentApplication.addEventListener(MouseEvent.MOUSE_UP, onMouseEventUp, true);
				}
			} else if (captionVO.movable) {
				this.addEventListener(MouseEvent.MOUSE_UP, onDragMouseUp);
				this.startDrag(false, new Rectangle(0, 0, parent.width - this.width, parent.height - this.height));
			}
		}

		private function onDragMouseUp(me:MouseEvent):void {
			this.removeEventListener(MouseEvent.MOUSE_UP, onDragMouseUp);
			this.stopDrag();
			lastX=this.mx_internal::$x;
			lastY=this.mx_internal::$y;
		}

		private function onMouseEventUp(me:MouseEvent):void {
			this.parentApplication.removeEventListener(MouseEvent.MOUSE_UP, onMouseEventUp);
			this.parentApplication.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			if (_dragPositionHolder) {
				captionVO.listenForChange();
				if (!_dragPositionHolder.equals(captionVO.pointPosition)) { //not same position
					captionVO.pointPosition=new EnumPosition(captionVO.pointPosition.ordinal);
				}
				_dragPositionHolder=null;
			}
		}

		private function onMouseMove(me:MouseEvent):void {
			captionVO.pointPosition=CaptionUtils.getDragPosition(this);
		}

		private function get captionVO():CaptionVO {
			return model as CaptionVO;
		}

	}
}
