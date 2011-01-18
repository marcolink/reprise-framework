/*
* Copyright (c) 2006-2010 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package reprise.utils
{
	import flash.events.Event;	
	import flash.events.EventDispatcher;
	
	import reprise.commands.AbstractAsynchronousCommand;	

	public class AsynchronousDelegate extends AbstractAsynchronousCommand
	{
		/***************************************************************************
		*							protected methods								   *
		***************************************************************************/
		protected var m_executionDelegate : Delegate;
		protected var m_waitsForEvent : Boolean = false;
		protected var m_commandCompleteEventName : String;
		protected var m_successEvaluationFunction : Function;
	
	
		/***************************************************************************
		*							public methods								   *
		***************************************************************************/
		public function AsynchronousDelegate(scope:Object, method:Function, 
			args:Array, commandCompleteEventName:String = null)
		{
			m_executionDelegate = new Delegate(scope, method, args);
			if (commandCompleteEventName != null)
			{
				m_waitsForEvent = true;
				m_commandCompleteEventName = commandCompleteEventName;
			}
			m_successEvaluationFunction = function(e:Event):Boolean{return true;};
		}
		
		public static function create(
			scope:Object, method:Function, ...args) : AsynchronousDelegate
		{
			return new AsynchronousDelegate(scope, method, args);
		}
		
		override public function execute(...args) : void
		{
			super.execute();
			if (m_waitsForEvent)
			{
				EventDispatcher(m_executionDelegate.scope()).addEventListener(
					m_commandCompleteEventName, execution_complete);
			}
			m_executionDelegate.execute();
			if (!m_waitsForEvent)
			{
				notifyComplete(true);
			}
		}
		
		public function waitsForEvent() : Boolean
		{
			return m_waitsForEvent;
		}
		public function setWaitsForEvent(val:Boolean) : void
		{
			m_waitsForEvent = val;
		}
		
		public function commandCompleteEventName() : String
		{
			return m_commandCompleteEventName;
		}
		public function setCommandCompleteEventName(val:String) : void
		{
			m_commandCompleteEventName = val;
		}
		
		public function successEvaluationFunction():Function
		{
			return m_successEvaluationFunction;
		}
		public function setSuccessEvaluationFunction(f:Function):void
		{
			m_successEvaluationFunction = f;
		}
		
		
		/***************************************************************************
		*							protected methods								   *
		***************************************************************************/
		protected function execution_complete(event : Event) : void
		{
			EventDispatcher(m_executionDelegate.scope()).removeEventListener(
				m_commandCompleteEventName, execution_complete);
			notifyComplete(m_successEvaluationFunction(event));
		}
	}
}