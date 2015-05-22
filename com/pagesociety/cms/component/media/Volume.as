package com.pagesociety.cms.component.media
{
	import com.pagesociety.ux.component.Component;
	import com.pagesociety.ux.component.Container;
	import com.pagesociety.ux.component.PSlider;
	import com.pagesociety.ux.component.SpriteComponent;
	import com.pagesociety.ux.component.dim.Guide;
	import com.pagesociety.ux.event.ComponentEvent;
	
	import flash.display.Graphics;
	import flash.geom.Point;

	[Event(type="com.pagesociety.ux.event.ComponentEvent", name="change_value")]
	public class Volume extends Container
	{
		
		private static const XO:Number = 8;
		private static const YO:Number = 5;
		private static const W:Number = 6;
		private static const H:Number = 12;
		private static const H1:Number = 75;
		private static const H2:Number = 40;
		private static const GAP:Number = 3;
		private static const BARS:uint = 3;
		
		private var _controller		:PSlider;
		private var _trigger		:Container;
//		private var _speaker		:SpriteComponent;
//		private var _mute_x			:SpriteComponent;
		
		private var _bg_color:uint = 0xcccccc;
		
		public function Volume(parent:Container, index:int=-1)
		{
			super(parent, index);
			
			// speaker/mute icons
			_trigger					= new Container(this);
			_trigger.backgroundVisible	= true;
			_trigger.backgroundAlpha	= 0;
			_trigger.addEventListener(ComponentEvent.CLICK, on_click);
			_trigger.addEventListener(ComponentEvent.ROLL_OVER, on_show);
			_trigger.addEventListener(ComponentEvent.ROLL_OUT, on_hide_delayed);
			
//			_speaker				= new SpriteComponent(_trigger, new VolumeIcon());
//			_speaker.x 				= 4;
//			_speaker.y				= 2;
//			_speaker.decorator.mouseChildren = false;
//			
//			_mute_x					= new SpriteComponent(_trigger, new MuteIcon());
//			_mute_x.x 				= 6;
//			_mute_x.y				= 4;
//			_mute_x.decorator.mouseChildren = false;
			
			// volume slider
			_controller			= new PSlider(this, PSlider.VERTICAL);
			_controller.x		= 0;
			_controller.y		= -H1;
			_controller.alpha   = 0;
			_controller.height 	= H1;
			_controller.backgroundColor = _bg_color;

			_controller.addEventListener(ComponentEvent.CHANGE_VALUE, on_change_volume);
			_controller.addEventListener(ComponentEvent.ROLL_OVER, on_over_control);
			_controller.addEventListener(ComponentEvent.ROLL_OUT, on_hide);
			
			width = 20;
		}
		
		private function on_show(e:*):void
		{
			_controller.alphaTo(1);
		}
		
		private function on_hide_delayed(e:*):void
		{
			execute_later(
				"hide", 
				function():void
				{ 
					_controller.alphaTo(0); 
				},
				600);
		}
		
		private function on_over_control(e:*):void
		{
			cancel_execute_late("hide");
		}
		
		private function on_hide(e:*):void
		{
			cancel_execute_late("hide");
			_controller.alphaTo(0);
		}
		
		public function get value():Number
		{
			return _controller.value;
		}
		
		public function set value(n:Number):void
		{
			_controller.value = n;
		}
		
		override public function render():void
		{
			
//			_mute_x.visible 			= _controller.value == 0;
//			_speaker.visible 			= _controller.value != 0;
			
			super.render();
		}
		
		private function on_change_volume(e:ComponentEvent):void
		{
			render();
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, value);
		}
		
		private function on_click(e:ComponentEvent):void
		{
			if (value==0)
				value = 1;
			else
				value = 0;
			render();
			dispatchComponentEvent(ComponentEvent.CHANGE_VALUE, this, value);
		}
	}
}