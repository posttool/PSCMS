package com.pagesociety.cms.component.media
{
	import com.pagesociety.persistence.Entity;
	import com.pagesociety.util.Locker;
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.PSlider;
	import com.pagesociety.ux.component.Slider;
	import com.pagesociety.ux.component.button.CirclePlayButton;
	import com.pagesociety.ux.component.dim.Guide;
	import com.pagesociety.ux.component.media.VideoControllerA;
	import com.pagesociety.ux.component.media.VideoPlayerA;
	import com.pagesociety.ux.component.text.Label;
	import com.pagesociety.ux.event.ComponentEvent;
	import com.pagesociety.ux.event.ResourceEvent;
	import com.pagesociety.web.ResourceUtil;
	
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	public class VideoControllerB extends VideoControllerA
	{
		private var _a:Component;
		private var _b:Container;
		private var _v:Volume;
		private var _play_lock:Locker = new Locker();

		public function VideoControllerB(parent:Container)
		{
			super(parent);
			
			_a = new Component(playControlContainer);
			_a.height = 120;
			_a.backgroundVisible = true;
			_a.alpha = 0;
			_a.alignY(Guide.BOTTOM);
			add_rollovers(_a);
			
			_b = new Container(playControlContainer);
			_b.height = 16;
			_b.alignY(Guide.BOTTOM,1);
			_b.backgroundVisible = true;
			_b.backgroundColor = 0xffffff;
			_b.backgroundShadowSize = 11;
			_b.backgroundShadowStrength = .17;
			_b.alpha = 0;
			add_rollovers(_b);
			
			bufferIndicatorRenderer = function (p:Container):Component
			{
				var buff:BufferIndicator = new BufferIndicator(p);
				buff.width = 130;
				buff.height = 20;
				buff.alignX(Guide.CENTER);
				buff.alignY(Guide.CENTER);
				return buff;
			}
			
			playButtonRenderer = function(p:Container):Component
			{
				var play:PlayButton = new PlayButton(_b);
				play.width = 20;
				play.height = _b.height;
				add_rollovers(play);
				return play;
			}
			
			pauseButtonRenderer = function(p:Container):Component
			{
				var pause:PauseButton = new PauseButton(_b);
				pause.width = 20;
				pause.height = _b.height;
				add_rollovers(pause);
				return pause;
			}
				
			seekerRenderer = function (p:Container):Component
			{
				var s:PSlider = new PSlider(_b,PSlider.HORIZONTAL);
				s.backgroundColor = 0xdddddd;
				s.margin.left = 20;
				s.margin.right = 90;
				add_rollovers(s);
				return s;
			}
			
//			timeDisplayRenderer = function(p:Container):Component
//			{
//				var l:MonoSpacedLabel = new MonoSpacedLabel(_b);
//				l.charWidth = 6;
//				l.fontStyle = "small";
//				l.alignX(Guide.RIGHT, -40);
//				l.alignY(Guide.CENTER,-1);
//				add_rollovers(l);
//				return l;
//			}

			volumeControlRenderer = function (p:Container):Component
			{
				_v = new Volume(_b);
				_v.alignX(Guide.RIGHT,-10);
				_v.addEventListener(ComponentEvent.CHANGE_VALUE, on_change_volume);
				add_rollovers(_v);
				return _v;
			}
				
			replayButtonRenderer = function (p:Container):Component
			{
				var replay:CirclePlayButton = new CirclePlayButton(p);
				replay.width 	= 180;
				replay.height = 180;
				replay.overAlpha   = 0.9;
				replay.normalAlpha = 0.3;
				replay.arrowNormalAlpha = 0.3;
				replay.arrowOverAlpha   = 0.7;
				replay.alignX(Guide.CENTER);
				replay.alignY(Guide.CENTER);
				return replay;
			}
				

			init();
			
			var vol:Number = application.getSharedObject("volume");
			if (isNaN(vol))
				vol = .5;
			_v.value = vol;
			volume = vol;
		}
		
		private function on_change_volume(e:*):void
		{
			application.setSharedObject("volume",_v.value, false);
		}
		
		private function add_rollovers(c:Component):void
		{
			c.addEventListener(ComponentEvent.ROLL_OVER, on_rollover);
			c.addEventListener(ComponentEvent.ROLL_OUT, on_rollout);
		}
		
		private function on_rollover(e:*):void
		{
			cancel_execute_late("X")
			 _b.alphaTo(1); 
		}
		
		private function on_rollout(e:*):void
		{
			execute_later("X",function():void{ _b.alphaTo(0); },1000);
		}
		
		public function set resource(resource:Entity):void
		{
			userObject = resource;
			_play_lock.wait(function():void
			{
				_play_lock.lock();
				ResourceUtil.getUrl(resource, 
					function(url:String):void
					{
						Logger.log("RESOURCE URL="+url);
						video.flv = url;
						_play_lock.unlock();
					});
			});
		}
		
		public function set flv(flv:String):void
		{
			video.flv = flv;
		}
		
		public function play():void
		{
			_play_lock.wait(function():void
			{
				video.play();
			})
		}
		
		override public function stop():void
		{
			super.stop();
			video.pause(true);
		}
		
		
	}
}