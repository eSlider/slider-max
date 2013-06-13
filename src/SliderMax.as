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
 * мой комментарий
 */
package
{
	import de.viscreation.VisApp;
	import de.viscreation.views.GalleryImage;
	import de.viscreation.views.SliderMaxGallery;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.DropShadowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import gs.TweenLite;
	
	[SWF(width='542', height='220', frameRate='60', backgroundColor="0x000000")]
	public class SliderMax extends Sprite
	{
		private var view:SlideMaxViewBase;
		private var gallery:SliderMaxGallery;

		public function SliderMax()
		{
			stage.align = "TL";
			stage.scaleMode = "noScale";
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			//Security.sandboxType  = Security.LOCAL_WITH_NETWORK
			
			var galleryImagesUrl:String = "images.xml";
			
			if( loaderInfo.parameters.hasOwnProperty("imagesUrl") ) {
				galleryImagesUrl = loaderInfo.parameters["imagesUrl"];
			}
			
			
			gallery = new SliderMaxGallery(galleryImagesUrl);
			
			addChild(view = new SlideMaxViewBase);
			view.removeChild(view.getChildAt(0));
			view.imagesContainer.addChild(gallery);
			visible = false;
			
			gallery.addEventListener(SliderMaxGallery.IMAGES_LOADED, initialize);
			stage.addEventListener(Event.MOUSE_LEAVE, handleMouse);
			stage.addEventListener(MouseEvent.MOUSE_OVER, handleMouse);
			stage.addEventListener(MouseEvent.MOUSE_OUT, handleMouse);
			
			stage.addEventListener(Event.RESIZE,resize);
			resize();
		}
		
		protected function resize(event:Event = null):void
		{
			var w:Number = stage.stageWidth;
			var h:Number = stage.stageHeight;
			
			with(view.rightArrow){
				x = w - width;
				arrow.y = Math.round((h-arrow.height)/2);
				backGround.height = h;
			}
			
			with(view.leftArrow){
				arrow.y = Math.round((h+arrow.height)/2);
				backGround.height = h;
			}
			
			gallery.width = w;
			gallery.height = h;
		}
		
		protected function handleMouse(event:Event):void
		{
			switch(event.type){
				case MouseEvent.MOUSE_OVER:
					gallery.stop();
					break;
				case MouseEvent.MOUSE_OUT:
				case Event.MOUSE_LEAVE:
					gallery.start();
					break;
			}
		}
		
		protected function initialize(event:Event):void
		{
			if(gallery.images.length < 2 ){
				view.leftArrow.visible = false;
				view.rightArrow.visible = false;
			}else{
				gallery.play();
				setupArrow(view.leftArrow);
				setupArrow(view.rightArrow);
			}
			visible = true;
		}
		
		private function setupArrow(button:MovieClip):void
		{
			with(button){
				buttonMode = true;
				mouseChildren = false;
				addEventListener(MouseEvent.MOUSE_OVER,onArrowMouseOver);
				addEventListener(MouseEvent.MOUSE_OUT,onArrowMouseOut);
				addEventListener(MouseEvent.CLICK,onClick);
				
				var arrow:MovieClip = getChildByName("arrow") as MovieClip;
				arrow.filters = [new DropShadowFilter(0,45,0,1,4,4,1,1)];
				arrow.alpha = 0.5;
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var arrow:MovieClip = event.target as MovieClip;
			if(arrow == view.leftArrow){ 
				gallery.showPrev();
			}else if(arrow == view.rightArrow){ 
				gallery.showNext();
			}
		}
		
		protected function onArrowMouseOver(event:MouseEvent):void
		{
			var arrow:MovieClip = event.target as MovieClip;
			var backGround:MovieClip = arrow.getChildByName("arrow") as MovieClip;
			TweenLite.to(backGround, 1, {alpha:1});
		}
		
		protected function onArrowMouseOut(event:MouseEvent):void
		{
			var arrow:MovieClip = event.target as MovieClip;
			var backGround:MovieClip = arrow.getChildByName("arrow") as MovieClip;
			TweenLite.to(backGround, 1, {alpha:0.5});
		}
	}
}