/*
* Copyright (c) 2006-2010 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

/**
 * @author till
 */
package reprise.css.math
{
	public class CSSCalculationPercentage 
		extends AbstractCSSCalculation 
	{
		//----------------------       Private / Protected Properties       ----------------------//
		private var _value : Number;
		
		//----------------------               Public Methods               ----------------------//
		public function CSSCalculationPercentage(valueString : String)
		{
			//TODO: check if we have to use parseFloat or parseInt
			_value = parseFloat(valueString) / 100;
		}
		
		public override function resolve(
			reference : Number, context : ICSSCalculationContext = null) : Number
		{
			return reference * _value;
		}
		
		public function toString() : String
		{
			return "relative value: " + (_value * 100) + "%";
		}
	}
}