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
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import gs.TweenLite;
	import gs.TweenMax;
	import flash.system.LoaderContext;
	
	public class GalleryImage extends Sprite
	{
		private var link:String;
		public var imageLoader:Loader;
		public var imageMask:Sprite;
		
		public static const READY:String = "ready"; // if image loaded successfully
		public static const VISIBLE:String = "visible";
		public static const INVISIBLE:String = "invisible";

		private var quad:Object = {width: 45, height: 45};
		private var drawedLines:int;

		private var linesShouldDrawed:Number;
		private var srcUrl:String;
		
		[Event(name="ready", type="flash.events.Event")]
		[Event(name="visible", type="flash.events.Event")]
		[Event(name="invisible", type="flash.events.Event")]
		public function GalleryImage(data:XML)
		{
			var src:String = String(data.@src);
			link = String(data.@link);
			load(src);
			
			//cacheAsBitmap = true;
			
			if(link != ""){
				buttonMode = true;
				addEventListener(MouseEvent.CLICK,onClick);
			}
		}
		
		public function enable():void{
			if(link != ""){
				buttonMode = true;
				mouseChildren = false;
			}else{
				buttonMode = false;
				mouseChildren = true;
			}
			mouseEnabled = true;
		}
		
		public function disable():void{
			mouseChildren = false;
			mouseEnabled = false;
			buttonMode = false;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(link));
		}
		
		private function load(src:String):void
		{
			var context:LoaderContext = new LoaderContext();
			var SecurityDomain:Object;

			imageLoader = new Loader();
			imageLoader.cacheAsBitmap = true;
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			imageLoader.load(new URLRequest(src));
			
			imageMask = new Sprite;
			//imageLoader.mask = imageMask;
			
			addChild(imageLoader);
		}
		
		public function show(animate:Boolean = false):void{
			if(animate){
				linesShouldDrawed = Math.round(imageLoader.width/quad.width)+1;
				drawedLines = 0;
				for (var i:int = 0; i < linesShouldDrawed; i++) 
				{
					drawVerticalMaskLine(i);
				}
			}else{
				imageLoader.alpha = 0;
				TweenMax.to(imageLoader,0.5,{alpha:1});
				imageMask.graphics.beginFill(0xFFFFFF,1);
				imageMask.graphics.drawRect(0,0,imageLoader.width, imageLoader.height);
				imageMask.graphics.endFill();
				dispatchEvent(new Event(VISIBLE));
			}
		}
		
		private function drawVerticalMaskLine(i:Number):void
		{
			var tween:Object = {height:0};
			imageMask.graphics.beginFill(0xFFFFFF,1);
			TweenMax.to(tween,0.5,{height: imageLoader.height, delay: (i/10), onUpdate:function():void{
				imageMask.graphics.drawRect(i*quad.width,0,quad.width, tween.height);
			},onComplete:function():void{
				drawedLines++;
				if(linesShouldDrawed == drawedLines){
					imageMask.graphics.endFill();
					dispatchEvent(new Event(VISIBLE));
				}
			}})
		}
		
		public function hide():void
		{
			imageMask.graphics.clear();
			dispatchEvent(new Event(INVISIBLE));
		}
		
		protected function onLoaderComplete(event:Event):void
		{
			dispatchEvent(new Event(READY));
		}
	}
}