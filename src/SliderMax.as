package
{
	import flash.display.Sprite;
	
	[SWF(width='540', height='220', frameRate='24', bbackgroundColor="0xFFFFFF")]
	public class SliderMax extends Sprite
	{

		private var slideMaxViewBase:SlideMaxViewBase;
		
		public function SliderMax()
		{
			slideMaxViewBase = new SlideMaxViewBase;
			addChild(slideMaxViewBase);
			
			stage.align = "TL";
			stage.scaleMode = "noScale";
		}
	}
}