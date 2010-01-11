/*
* Copyright (c) 2006-2010 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package reprise.commands
{ 
	import reprise.commands.IAsynchronousCommand;
	
	public interface IProgressCommand extends IAsynchronousCommand
	{
		function progress() : Number;
	}
}