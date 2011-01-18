/*
* Copyright (c) 2006-2010 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package reprise.core
{
	import reprise.ui.DocumentView;
	import reprise.ui.UIObject;
	import reprise.utils.DisplayListUtil;

	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	use namespace reprise;

	public class FocusManager
	{
		/***************************************************************************
		*							public properties							   *
		***************************************************************************/
		public static const FOCUS_METHOD_KEYBOARD : String = 'keyboard';
		public static const FOCUS_METHOD_MOUSE : String = 'mouse';
		
		
		/***************************************************************************
		*							protected properties						   *
		***************************************************************************/
		protected var m_document : DocumentView;
		protected var m_focus : UIObject;
		protected var m_inFocusHandling : Boolean;
		protected var m_lastTabPress : int;
		
		
		/***************************************************************************
		*							public methods								   *
		***************************************************************************/
		public function FocusManager(document : DocumentView)
		{
			m_document = document;
			document.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, document_keyFocusChange);
			document.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, document_mouseFocusChange);
			document.addEventListener(FocusEvent.FOCUS_IN, document_focusIn);
			document.addEventListener(MouseEvent.MOUSE_DOWN, document_mouseDown);
		}
		
		/**
		 * Because of the entirely borked focus management of the Flash Player, we need to make 
		 * sure that we really, really get the focus under all conditions. As it turns out, in 
		 * certain cases, the player doesn't even dispatch a FOCUS_IN event for TextFields when 
		 * they are clicked.
		 * This method catches these cases.
		 */
		protected function document_mouseDown(event : MouseEvent) : void
		{
			var element : UIObject = DisplayListUtil.locateElementContainingDisplayObject(
				DisplayObject(event.target), true);
			if (element == m_focus)
			{
				return;
			}
			setFocusedElement(element, FOCUS_METHOD_MOUSE);
		}

		reprise function setFocusedElement(element : UIObject, method : String) : Boolean
		{
			if (m_focus && m_focus == element)
			{
				return false;
			}
			if (m_focus)
			{
				m_focus.setFocus(false, method);
			}
			m_focus = element;
			if (element && element.document == m_document)
			{
				element.setFocus(true, method);
				return true;
			}
			//else
//			m_document.stage.focus = null;
			m_focus = null;
			return false;
		}
		
		/***************************************************************************
		*							protected methods							   *
		***************************************************************************/
		protected function document_keyFocusChange(e:FocusEvent):void
		{
			if (m_inFocusHandling)
			{
				return;
			}
			m_inFocusHandling = true;
			if (e.keyCode == Keyboard.TAB && !e.isDefaultPrevented())
			{
				if (getTimer() - m_lastTabPress < 15)
				{
					e.preventDefault();
					m_inFocusHandling = false;
					return;
				}
				m_lastTabPress = getTimer();
				var focusView:UIObject;
				if (e.shiftKey)
				{
					focusView = m_focus != null 
						? m_focus.previousValidKeyView() 
						: m_document.previousValidKeyView();
				}
				else
				{
					focusView = m_focus != null 
						? m_focus.nextValidKeyView() 
						: m_document.nextValidKeyView();
				}
				if (setFocusedElement(focusView, FOCUS_METHOD_KEYBOARD))
				{
		            e.preventDefault();
				}
	        }
			m_inFocusHandling = false;
		}
		protected function document_mouseFocusChange(event : FocusEvent) : void
		{
			if (m_inFocusHandling)
			{
				return;
			}
			m_inFocusHandling = true;
			var element : DisplayObject = DisplayObject(event.relatedObject);
			var focusedElement : UIObject = DisplayListUtil.locateElementContainingDisplayObject(
				element, true);
			if (setFocusedElement(focusedElement, FOCUS_METHOD_MOUSE))
			{
				event.preventDefault();
			}
			m_inFocusHandling = false;
		}
		
		protected function document_focusIn(event : FocusEvent) : void
		{
			if (m_inFocusHandling)
			{
				return;
			}
			m_inFocusHandling = true;
			var focusedElement : UIObject = DisplayListUtil.locateElementContainingDisplayObject(
				DisplayObject(event.target), true);
			if (m_focus != focusedElement)
			{
				if (setFocusedElement(focusedElement, FOCUS_METHOD_MOUSE))
				{
					event.preventDefault();
				}
			}
			m_inFocusHandling = false;
		}
	}
}
