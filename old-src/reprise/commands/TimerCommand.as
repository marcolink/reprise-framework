/*
* Copyright (c) 2006-2010 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package reprise.commands
{
	
	import reprise.commands.AbstractAsynchronousCommand;
	import flash.utils.Timer;
	import flash.events.TimerEvent;


	public class TimerCommand extends AbstractAsynchronousCommand
	{
		
		private var m_timer:Timer;
		
		
		public function TimerCommand(delay:Number)
		{
			super();
			m_timer = new Timer(delay, 1);
			m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timer_complete);
		}
		
		public override function execute(...args):void
		{
			super.execute();
			m_timer.start();
		}
		
		public override function cancel():void
		{
			m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timer_complete);
			m_timer.stop();
			super.cancel();
		}
		
		protected function timer_complete(e:TimerEvent):void
		{
			m_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timer_complete);
			notifyComplete(true);
		}
	}
}