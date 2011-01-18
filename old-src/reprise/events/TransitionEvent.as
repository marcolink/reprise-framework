/*
* Copyright (c) 2006-2010 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package reprise.events 
{
	import flash.events.Event;
	
	/**
	 * @author till
	 */
	public class TransitionEvent extends Event 
	{
		/***************************************************************************
		*							public properties							   *
		***************************************************************************/
		public static const TRANSITION_START : String = 'transitionStart';
		public static const TRANSITION_COMPLETE : String = 'transitionComplete';
		public static const ALL_TRANSITIONS_COMPLETE : String = 'allTransitionComplete';
		public static const TRANSITION_CANCEL : String = 'transitionCancel';
		
		/**
		 * Returns the name of the property whose transition has ended.
		 * 
		 * Note that this property is not defined for events of type 
		 * ALL_TRANSITIONS_COMPLETE
		 */
		public function get propertyName() : String
		{
			return m_propertyName;
		}
		/**
		 * Returns the elapsed amount of time, in seconds.
		 * 
		 * Note that this property is not defined for events of type 
		 * ALL_TRANSITIONS_COMPLETE
		 */
		public function get elapsedTime() : int
		{
			return m_elapsedTime;
		}
		public function set propertyName(name : String) : void
		{
			m_propertyName = name;
		}
		public function set elapsedTime(time : int) : void
		{
			m_elapsedTime = time;
		}

		
		/***************************************************************************
		*							protected properties							   *
		***************************************************************************/
		protected var m_propertyName : String;
		protected var m_elapsedTime : int;

		
		/***************************************************************************
		*							public methods								   *
		***************************************************************************/
		public function TransitionEvent(type : String, bubbles : Boolean = false)
		{
			super(type, bubbles);
		}
		
		public override function toString() : String
		{
			var str : String = 'TransitionEvent.' + type;
			if (type == TRANSITION_START || 
				type == TRANSITION_COMPLETE || type == TRANSITION_CANCEL)
			{
				str += ', propertyName = ' + m_propertyName;
			}
			if (type != TRANSITION_START)
			{
				str += ', elapsedTime = ' + m_elapsedTime;
			}
			return str;
		}
	}
}
