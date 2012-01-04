package itrain.lessoneditor.other
{
	import mx.core.IFactory;
	
	public class LessonEditorHandleFactory implements IFactory
	{
		public function newInstance():*
		{
			return new SpriteHandle();
		}
	}
}