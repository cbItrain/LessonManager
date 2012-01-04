package itrain.lessoneditor.model
{
	import itrain.common.model.vo.SlideVO;

	public class SlideIndex
	{
		public var index:int;
		public var slide:SlideVO;
		
		public function SlideIndex(index:int, slide:SlideVO)
		{
			this.index = index;
			this.slide = slide;
		}
	}
}