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
package de.viscreation.views
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import gs.TweenLite;
	
	public class SliderMaxGallery extends Sprite
	{
		private var xmlLoader:URLLoader;
		private var images:Array;
		private var imagesReady:int;
		private var currentImage:GalleryImage;
		private var lastImage:GalleryImage;
		private var _swapTime:Number;
		
		public static const IMAGES_LOADED:String = "imagesLoaded"; // if all images ready

		
		[Event(name="ready", type="flash.events.Event")]
		public function SliderMaxGallery(imagesXmlUrl:String, swapTime:Number = 2)
		{
			load(imagesXmlUrl);
			addEventListener(SliderMaxGallery.IMAGES_LOADED, play);
			_swapTime = swapTime;
		}
		
		public function play(event:Event = null):void
		{
			TweenLite.to({}, _swapTime, {onComplete:function():void{
				showNext();
				trace("next");
			}});
		}
		
		public function showNext(event:Event = null):void
		{
			currentImage = getNextImage();
			addChild(currentImage);
			currentImage.show();
			currentImage.addEventListener(GalleryImage.VISIBLE,onImageShowed);
		}
		
		private function getNextImage():GalleryImage
		{
			var image:GalleryImage;
			var fondedImage:GalleryImage = currentImage;
			
			lastImage = currentImage;
			// set current image and find last one
			for each(image in images){
				if(fondedImage == null){
					fondedImage = image;
					break;
				}
				
				if(fondedImage == image){
					fondedImage = null;
				}
			}
			fondedImage = image;
			
			return fondedImage;
		}
		
		protected function onImageShowed(event:Event):void
		{
			trace("showed")
			if(lastImage){
				lastImage.hide();
				lastImage = null;
			}
			
			play();
		}
		
		private function load(xmlUrl:String):void
		{
			images = new Array;
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, onXmlLoadComplete);
			xmlLoader.load(new URLRequest(xmlUrl));
		}
		
		protected function onXmlLoadComplete(e:Event):void
		{
			XML.ignoreWhitespace = true;
			imagesReady = 0
				
			var data:XML = new XML(e.target.data);
			for each ( var imageXml:XML in data.image as XMLList){
				var src:Object;
				var image:GalleryImage = new GalleryImage(imageXml);
				image.addEventListener(GalleryImage.READY,onImageReady);
				images.push(image);
			}
		}
		
		protected function onImageReady(event:Event):void
		{
			imagesReady++;
			if(images.length == imagesReady){
				dispatchEvent(new Event(IMAGES_LOADED));
			}
		}
	}
}