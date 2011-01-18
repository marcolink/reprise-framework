/*
* Copyright (c) 2006-2010 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package reprise.ui.renderers
{
	import reprise.events.DisplayEvent;
	import reprise.controls.Label;
	import reprise.core.reprise;
	import reprise.css.propertyparsers.DisplayPosition;
	import reprise.ui.UIComponent;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	use namespace reprise;
	
	public class AbstractTooltip extends UIComponent
	{
			
		/***************************************************************************
		*							public properties							   *
		***************************************************************************/
		public static var className : String = "AbstractTooltip";
		
		
		/***************************************************************************
		*							protected properties						   *
		***************************************************************************/
		protected var m_mousedElement : DisplayObject;
		protected var m_mousedComponent : UIComponent;
		protected var m_tooltipDataProvider : Object;
		protected var m_label : Label;
			
		
		/***************************************************************************
		*							public methods								   *
		***************************************************************************/	
		public function AbstractTooltip()
		{
		}
	
		
		public function setData(data : Object) : void
		{
			m_tooltipData = data;
			m_label.setLabel(String(data));
		}
		
		public function data() : Object
		{
			return m_tooltipData;
		}
		
		public function updatePosition() : void
		{
			var pos : Point;
			switch (style.position)
			{
				case DisplayPosition.POSITION_ABSOLUTE:
				{
					if (!m_mousedComponent)
					{
						return;
					}
					pos = positionRelativeToElement(m_mousedComponent);
					break;
				}
				case DisplayPosition.POSITION_FIXED:
				{
					pos = positionRelativeToElement(stage);
					break;
				}
				case DisplayPosition.POSITION_STATIC:
				{
					// there seems to be a problem with sprites which are freshly inserted into the
					// view hierarchy. most probably it takes a sec before their stage attribute is 
					// set, so we take care of this here. one frame later everything will be fine 
					// again.
					if (!(m_mousedElement && m_mousedElement.stage))
					{
						return;
					}
					pos = positionRelativeToMouse();
					break;
				}
			}
			setPosition(pos.x, pos.y);
		}

		public function setPosition(xValue:Number, yValue:Number) : void
		{
			var newPos : Point = new Point(xValue, yValue);
			newPos = stage.localToGlobal(newPos);
			newPos.y = Math.max(-m_currentStyles.marginTop, newPos.y + m_currentStyles.marginTop);
			newPos.y = Math.min(stage.stageHeight - outerHeight - m_currentStyles.marginTop, newPos.y);
			newPos.x = Math.max(-m_currentStyles.marginLeft, newPos.x + m_currentStyles.marginLeft);
			newPos.x = Math.min(stage.stageWidth - outerWidth - m_currentStyles.marginLeft, newPos.x);
			newPos = parent.globalToLocal(newPos);
			x = newPos.x;
			y = newPos.y;
		}
		
		public function setMousedElement(mousedElement : DisplayObject) : void
		{
			m_mousedElement = mousedElement;
		}
		
		public function mousedElement() : DisplayObject
		{
			return m_mousedElement;
		}
		
		public function setMousedComponent(mousedComponent:UIComponent):void
		{
			m_mousedComponent && m_mousedComponent.removeEventListener(
				DisplayEvent.VALIDATION_COMPLETE, mousedEvent_validationComplete);
			m_mousedComponent = mousedComponent;
			m_mousedComponent && m_mousedComponent.addEventListener(
				DisplayEvent.VALIDATION_COMPLETE, mousedEvent_validationComplete);
			validateElement(true, true);
			updatePosition();
		}

		public function mousedComponent():UIComponent
		{
			return m_mousedComponent;
		}
		
		public function setTooltipDataProvider(target:Object) : void
		{
			m_tooltipDataProvider = target;
		}
		
		public function tooltipDataProvider() : Object
		{
			return m_tooltipDataProvider;
		}

		override public function remove(...args : *) : void
		{
			m_mousedComponent && m_mousedComponent.removeEventListener(
				DisplayEvent.VALIDATION_COMPLETE, mousedEvent_validationComplete);
			super.remove(args);
		}

		
		/***************************************************************************
		*							protected methods								   *
		***************************************************************************/
		protected override function createChildren() : void
		{
			m_label = Label(addChild(new Label()));
			m_label.cssClasses = 'tooltipLabel';
		}
		
		protected override function initDefaultStyles() : void
		{
			super.initDefaultStyles();
			m_elementDefaultStyles.setStyle('position', 'static');
			m_elementDefaultStyles.setStyle('top', '18');
			m_elementDefaultStyles.setStyle('left', '0');
		}
		
		protected override function refreshSelectorPath() : void
		{
			var oldPath:String = m_selectorPath || '';
			super.refreshSelectorPath();
			if (m_mousedComponent is UIComponent)
			{
				m_selectorPath = UIComponent(m_mousedComponent).selectorPath + 
					' ' + m_selectorPath.split(' ').pop();
			}
			else
			{
				var basePathParts : Array = oldPath.split(' ');
				basePathParts.pop();
				basePathParts.push(m_selectorPath.split(' ').pop());
				m_selectorPath = basePathParts.join(' ');
			}
			if (m_selectorPath != oldPath)
			{
				m_selectorPathChanged = true;
				return;
			}
			m_selectorPathChanged = false;
		}

		protected override function resolveContainingBlock() : void
		{
			m_containingBlock = m_rootElement;
		}
		
		protected override function resolvePositioningProperties() : void
		{
			m_positionInFlow = 0;
		}
		
		protected function positionRelativeToElement(element:DisplayObject) : Point
		{
			var pos : Point = new Point();
			if (style.right && !style.left)
			{
				pos.x = element.width - style.right - width;
			}
			else
			{
				pos.x = style.left;
			}
			
			if (style.bottom && !style.top)
			{
				pos.y = element.height - style.bottom - height;
			}
			else
			{
				pos.y = style.top;
			}
			return element.localToGlobal(pos);
		}
		
		protected function positionRelativeToMouse() : Point
		{
			var pos : Point = new Point();
			pos.x = m_mousedElement.stage.mouseX + style.left;
			pos.y = m_mousedElement.stage.mouseY + style.top;
			return pos;
		}
		
		protected override function validateAfterChildren() : void
		{
			super.validateAfterChildren();
			applyOutOfFlowChildPositions();
		}
		
		protected function mousedEvent_validationComplete(event : DisplayEvent) : void
		{
			m_mousedComponent.document.addEventListener(
				DisplayEvent.DOCUMENT_VALIDATION_COMPLETE, document_validationComplete);
		}
		
		protected function document_validationComplete(event : DisplayEvent) : void
		{
			m_mousedComponent.document.removeEventListener(
				DisplayEvent.DOCUMENT_VALIDATION_COMPLETE, document_validationComplete);
			validateElement(true, true);
			updatePosition();
		}
	}
}