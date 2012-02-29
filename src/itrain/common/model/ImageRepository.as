package itrain.common.model {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.utils.Dictionary;
    
    import itrain.common.events.ImageRepositoryEvent;
    import itrain.common.model.loader.ImageLoader;
    
    import mx.core.FlexGlobals;
    
    import spark.components.Image;

    public class ImageRepository extends EventDispatcher {
        [Bindable]
        [Embed(source="assets/basicBlackPreloader.swf")]
        public static var loaderSpinner:Class;

        private static var _loadQueue:Vector.<String>=new Vector.<String>();

        private static var _imageRIList:Vector.<ImageRepositoryItem>=new Vector.<ImageRepositoryItem>();

        private var _current:String;
        private var _loader:ImageLoader;

        private static var _instance:ImageRepository;
		private static var _cacheHelper:CacheHelper;

        public function ImageRepository() {
            _loader=new ImageLoader();
            _loader.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
            _loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError, false, 0, true);
			
			_cacheHelper = new CacheHelper();
			
			setCacheSize(FlexGlobals.topLevelApplication.parameters.maxImages);
        }

        public function clearCache(listOfURLs:Array):void {
			var index:int;
			for each (var s:String in listOfURLs) {
                if (s) {
					_cacheHelper.setBitmapData(s, null);
                }
            }
            var ire:ImageRepositoryEvent=new ImageRepositoryEvent(ImageRepositoryEvent.CACHE_CLEARED);
            ire.data=listOfURLs;
            dispatchEvent(ire);
        }

        public function clearAllCache():void {
			var vector:Vector.<String> = _cacheHelper.currentURLs.concat();
			_cacheHelper.removeAllURLs();
            var ire:ImageRepositoryEvent=new ImageRepositoryEvent(ImageRepositoryEvent.CACHE_CLEARED);
            ire.data=vector;
			ire.url="stopLoading"
            dispatchEvent(ire);
        }

        public function cacheLimitReached():Boolean {
            return _cacheHelper.cacheSizeReached();
        }

        public static function getInstance():ImageRepository {
            if (!_instance)
                _instance=new ImageRepository();
            return _instance;
        }

//        private function updateCache(url:String):void {
//            _cacheHelper.addToCurrentURLs(url);
//            //Clear cache if necessary
//            if (_cacheHelper.currentURLsSize > _cacheHelper.cacheSize) { //clear cache
//                var removed:String=_cacheHelper.shiftCurrentURL();
//                var bd:BitmapData=_cacheHelper.getBitmapData(removed);
//                if (bd) {
//					_cacheHelper.setBitmapData(removed, null);
//                }
//            }
//        }

        public function imageData(url:String, important:Boolean=true, image:Image=null):BitmapData {
            var result:BitmapData=_cacheHelper.getBitmapData(url);
            if (image) {
                cleanImageList(image, important);
				_cacheHelper.addImage(image);
			}
            if (!result) {
                updateLists(url, image);
                if (_current != url) {
                    if (important)
                        _loadQueue.unshift(url);
                    else
                        _loadQueue.push(url);
                }
                loadQueue();
            }
            return result;
        }

        private function updateLists(url:String, image:Image):void {
            cleanRepository(url);
            if (image) {
                _imageRIList.push(new ImageRepositoryItem(url, image));
            }
        }

        private function cleanImageList(image:Image, important:Boolean):void {
            if (_imageRIList.length) {
                var i:int;
                var removedItem:ImageRepositoryItem;
                var removed:Boolean=false
                if (important) {
                    for (i=_imageRIList.length - 1; i >= 0; i--) {
                        removedItem=_imageRIList[i];
                        if (removedItem.image == image) {
                            _imageRIList.splice(i, 1);
                            removed=true;
                            break;
                        }
                    }
                } else {
                    for (i=0; i < _imageRIList.length; i++) {
                        removedItem=_imageRIList[i];
                        if (removedItem.image == image) {
                            _imageRIList.splice(i, 1);
                            removed=true;
                            break;
                        }
                    }
                }
                if (removed && _current != removedItem.url) {
                    cleanRepository(removedItem.url);
                }
            }
        }

        private function cleanRepository(url:String):void {
            var index:int=_loadQueue.indexOf(url);
            if (index > -1)
                _loadQueue.splice(index, 1);
        }

        private function checkImageQueue():void {
            if (_imageRIList.length) {
                for each (var iri:ImageRepositoryItem in _imageRIList) {
                    _loadQueue.push(iri.url);
                }
                loadQueue();
            }
        }

        private function loadQueue():void {
            if (!_current) {
                if (_loadQueue.length) {
                    _current=_loadQueue.shift();
                    _loader.load(_current);
                } else {
                    checkImageQueue();
                }
            }
        }

        private function onLoadComplete(e:Event):void {
			var currentURL:String = _current;
			//updateCache(currentURL);
            var bitmapData:BitmapData=new BitmapData(_loader.contentWidth, _loader.contentHeight, true, 0x00ffffff);
            bitmapData.draw(_loader.content);
			_cacheHelper.setBitmapData(currentURL, bitmapData);
            var ire:ImageRepositoryEvent=new ImageRepositoryEvent(ImageRepositoryEvent.IMAGE_LOADED, bitmapData, _current, true);
            var imageUpdated:Boolean = updateImages(currentURL, bitmapData);
            _current=null;
            loadQueue();
			if (imageUpdated)
            	dispatcheNotificationEvent(ire);
			else if (_cacheHelper.cacheSizeReached()) {
				_cacheHelper.setBitmapData(currentURL, null);
			}
        }

        private function dispatcheNotificationEvent(e:Event):void {
            dispatchEvent(e);
        }

        private function updateImages(url:String, bitmapData:BitmapData, loaded:Boolean=true):Boolean {
            var iri:ImageRepositoryItem;
            var ire:ImageRepositoryEvent;
			var result:Boolean = false;
            for (var i:int=0; i < _imageRIList.length; i++) {
                iri=_imageRIList[i];
                if (iri.url == url) {
					result = true;
                    if (loaded) {
                        iri.image.source=new Bitmap(bitmapData);
                        ire=new ImageRepositoryEvent(ImageRepositoryEvent.IMAGE_UPDATED);
                        ire.bitmapData=bitmapData;
                    } else {
                        ire=new ImageRepositoryEvent(ImageRepositoryEvent.IMAGE_NOT_UPDATED);
                    }
                    iri.image.dispatchEvent(ire);
                    _imageRIList.splice(i, 1);
                }
            }
			return result;
        }

        public function isLoading():Boolean {
            return _current != null;
        }

        private function onError(e:Event):void {
            var ire:ImageRepositoryEvent=new ImageRepositoryEvent(ImageRepositoryEvent.IMAGE_NOT_LOADED, null, _current, true);
            updateImages(_current, null, false);
			_cacheHelper.setBitmapData(_current, new BitmapData(1,1));
            _current=null;
            loadQueue();
            dispatcheNotificationEvent(ire);
        }

        public function isBitmapDataAvailable(bd:BitmapData):Boolean {
			return _cacheHelper.isBitmapAvailable(bd);
		}

        private function setCacheSize(count:Number):void {
            if (count && !isNaN(count)) {
                _cacheHelper.cacheSize=count;
            }
        }
    }
}
