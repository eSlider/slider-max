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
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class GalleryImage extends Sprite
	{
		private var link:String;
		public var imageLoader:Loader;
		
		public static const READY:String = "ready"; // if image loaded successfully
		
		[Event(name="ready", type="flash.events.Event")]
		public function GalleryImage(data:XML)
		{
			var src:String = String(data.@src);
			link = String(data.@link);
			load(src);
			
			buttonMode = true;
			addEventListener(MouseEvent.CLICK,onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			navigateToURL(new URLRequest(link));
		}
		
		private function load(src:String):void
		{
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			imageLoader.load(new URLRequest(src));
			addChild(imageLoader);
		}
		
		protected function onLoaderComplete(event:Event):void
		{
			dispatchEvent(new Event(READY));
		}
	}
}