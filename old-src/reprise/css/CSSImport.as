/*
* Copyright (c) 2006-2010 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package reprise.css
{
	import reprise.external.URLLoaderResource;
	
	internal class CSSImport extends URLLoaderResource
	{
		//----------------------             Public Properties              ----------------------//
		protected var _owner : CSS;
		
		
		//----------------------               Public Methods               ----------------------//
		public function CSSImport(owner:CSS, url:String = null)
		{
			_owner = owner;
			setURL(url);
		}
		
		
		//----------------------         Private / Protected Methods        ----------------------//
		protected override function notifyComplete(success:Boolean) : void
		{
			if (success)
			{
				_owner.resolveImport(this);
			}
			super.notifyComplete(success);
		}	
	}
}