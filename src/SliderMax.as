/**
 * Copyright (c) 2013, VisCreation 
 * All rights reserved.
 * 
 * 
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are
 * met:

 * * Redistributions of source code must retain the above copyright notice, 
 * this list of conditions and the following disclaimer.
 * 
 * * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the 
 * documentation and/or other materials provided with the distribution.
 * 
 * * Neither the name of VisCreation nor the names of its 
 * contributors may be used to endorse or promote products derived from 
 * this software without specific prior written permission.
 * *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * @author <Andriy Oblivantsev> eslider@gmail.com
 * 
 */
package
{
	import de.viscreation.views.GalleryImage;
	import de.viscreation.views.SliderMaxGallery;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import gs.TweenLite;
	
	[SWF(width='540', height='220', frameRate='24', bbackgroundColor="0xFFFFFF")]
	public class SliderMax extends Sprite
	{
		private var view:SlideMaxViewBase;
		private var gallery:SliderMaxGallery;
		
		public function SliderMax()
		{
			stage.align = "TL";
			stage.scaleMode = "noScale";
			
			addChild(view = new SlideMaxViewBase);
			view.removeChild(view.getChildAt(0)); // remove standard image
			gallery = new SliderMaxGallery("images.xml");
			view.imagesContainer.addChild(gallery);
			
			setupArrow(view.leftArrow);
			setupArrow(view.rightArrow);
		}
		
		private function setupArrow(arrow:MovieClip):void
		{
			arrow.buttonMode = true;
			arrow.mouseChildren = false;
			arrow.addEventListener(MouseEvent.MOUSE_OVER,onArrowMouseOver);
			arrow.addEventListener(MouseEvent.MOUSE_OUT,onArrowMouseOut);
			
			var backGround:MovieClip = arrow.getChildByName("backGround") as MovieClip;

			backGround.alpha = 0;
		}
		
		protected function onArrowMouseOver(event:MouseEvent):void
		{
			var arrow:MovieClip = event.target as MovieClip;
			var backGround:MovieClip = arrow.getChildByName("backGround") as MovieClip;
			TweenLite.to(backGround, 1, {alpha:0.5});
		}
		protected function onArrowMouseOut(event:MouseEvent):void
		{
			var arrow:MovieClip = event.target as MovieClip;
			var backGround:MovieClip = arrow.getChildByName("backGround") as MovieClip;
			TweenLite.to(backGround, 1, {alpha:0});
		}
	}
}