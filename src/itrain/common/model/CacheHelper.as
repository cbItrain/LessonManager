package itrain.common.model {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import spark.components.Image;

	public class CacheHelper {
		
		private var _images:Vector.<Image>=new Vector.<Image>();
		private var _loadHistory:Vector.<String>=new Vector.<String>();
		private var _repository:Dictionary=new Dictionary(true);

		public var cacheSize:int=30;
		
		public function addImage(image:Image):void {
			var index:int=_images.indexOf(image);
			if (index < 0) {
				_images.push(image);
				image.addEventListener(Event.REMOVED_FROM_STAGE, onImageRemoveFromStage);
			} else if (cacheSizeReached()) {
				disposeIfNotUsed(image);
			}
		}

		private function disposeIfNotUsed(image:Image):void {
			if (image.source && image.source is Bitmap) {
				var bd:BitmapData = (image.source as Bitmap).bitmapData;
				image.source=null;
				disposeIfNotUsedBitmapData(bd);
			}
		}
		
		private function disposeIfNotUsedBitmapData(bd:BitmapData):void {
			if (bd) {
				if (!isBitmapDataUsed(bd))
					bd.dispose();
			}
		}
		
		private function isBitmapDataUsed(bd:BitmapData):Boolean {
			if (bd) {
				for each (var i:Image in _images) {
					if (i.source && (i.source is Bitmap) && (i.source as Bitmap).bitmapData == bd) {
						return true;
					}
				}
			}
			return false;
		}

		private function onImageRemoveFromStage(e:Event):void {
			var image:Image=e.currentTarget as Image;
			var index:int=_images.indexOf(image);
			if (index > -1) {
				_images.splice(index, 1);
				disposeIfNotUsed(image);
			}
		}
		
		public function getBitmapData(s:String):BitmapData {
			var result:BitmapData = _repository[s];
			if (isBitmapAvailable(result))
				return result
			else
				return null;
		}
		
		public function setBitmapData(s:String, bd:BitmapData):void {
			if (bd) {
				var index:int = _loadHistory.indexOf(s);
				if (index > -1) {
					_repository[s] = bd;
				} else {
					if (cacheSizeReached()) {//find first not used
						removeFirstUnused();
					} else {
						_loadHistory.push(s);
						_repository[s] = bd;
					}
				}
			} else {
				disposeIfNotUsedBitmapData(_repository[s] as BitmapData);
				removeFromCurrentURLs(s);
			}
			_repository[s] = bd;
		}
		
		private function removeFirstUnused():void {
			var bd:BitmapData;
			for each (var s:String in _loadHistory) {
				bd = _repository[s];
				if (isBitmapAvailable(bd)) {
					if (!isBitmapDataUsed(bd)) {
						removeFromCurrentURLs(s);
						bd.dispose();
						return;
					}
				}
			}
		}
		
		public function cacheSizeReached():Boolean {
			return currentURLsSize >= cacheSize;
		}

		private function removeFromCurrentURLs(url:String):void {
			var index:int=_loadHistory.indexOf(url);
			if (index > -1)
				_loadHistory.splice(index, 1);
		}

		public function removeAllURLs():void {
			var url:String;
			var bd:BitmapData;
			while (_loadHistory.length) {
				url = _loadHistory.shift();
				bd = _repository[url];
				_repository[url] = null;
				if (bd)
					bd.dispose();
			};
		}

		public function get currentURLs():Vector.<String> {
			return _loadHistory;
		}

		public function get currentURLsSize():int {
			return _loadHistory.length;
		}

		public function addToCurrentURLs(url:String):void {
			_loadHistory.push(url);
		}

		public function shiftCurrentURL():String {
			return _loadHistory.shift();
		}
		
		public function isBitmapAvailable(bitmapData:BitmapData):Boolean {
			try {
				return bitmapData && bitmapData.width > 1 && bitmapData.height > 1;
			} catch (e:Error) {
				return false;
			}
			return false;
		}
	}
}
