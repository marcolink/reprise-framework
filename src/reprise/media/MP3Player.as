/*
* Copyright (c) 2006-2010 the original author or authors
* 
* Permission is hereby granted to use, modify, and distribute this file 
* in accordance with the terms of the license agreement accompanying it.
*/

package reprise.media
{
	import reprise.external.IResource;
	import reprise.external.MP3Resource;
	import reprise.media.AbstractPlayer;

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class MP3Player extends AbstractPlayer
	{
		
		protected var m_sound:Sound;
		protected var m_soundTransform:SoundTransform;
		protected var m_soundChannel:SoundChannel;
		
		
		
		/***************************************************************************
		*							public methods								   *
		***************************************************************************/
		public function MP3Player(resource:IResource)
		{
			super();
			setResource(resource);
			m_soundTransform = new SoundTransform(1.0, 0.0);
		}

		public override function bytesLoaded():Number
		{
			return m_sound ? m_sound.bytesLoaded : 0;
		}

		public override function bytesTotal():Number
		{
			return m_sound ? m_sound.bytesTotal : 0;
		}
		
		public override function isBuffered():Boolean
		{
			return m_sound 
				? !m_sound.isBuffering && super.isBuffered() 
				: false;
		}
		
		public override function position():Number
		{
			if (!m_sound) return 0;
			if (m_soundChannel)
			{
				return m_soundChannel.position / 1000;
			}
			return m_recentPosition;
		}
		
		public override function duration():Number
		{
			if (!m_sound) return 0;
			return m_sound.length / (m_sound.bytesLoaded / m_sound.bytesTotal) / 1000;
		}
		
		
		
		/***************************************************************************
		*							protected methods							   *
		***************************************************************************/
		protected override function doLoad():void
		{
			m_source.execute();
			m_sound = Sound(MP3Resource(m_source).content());
			m_sound.addEventListener(Event.ID3, sound_id3);
		}

		protected override function doUnload():void
		{
			try
			{
				m_sound.close();
			}
			catch (e:Error)
			{
				log('w ' + e);
			}
		}
		
		protected override function doPlay():void
		{
			if (m_soundChannel)
			{
				m_soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundChannel_complete);
			}
			m_soundChannel = m_sound.play(m_recentPosition * 1000, 0, m_soundTransform);
			m_soundChannel.addEventListener(Event.SOUND_COMPLETE, soundChannel_complete);
		}

		protected override function doPause():void
		{
			m_soundChannel.stop();
		}

		protected override function doStop():void
		{
			m_soundChannel.stop();
		}

		protected override function doSeek(offset:Number):void
		{
			if (!isPlaying())
			{
				m_recentPosition = offset;
				return;
			}
			pause();
			m_recentPosition = offset;
			play();
		}
		
		protected override function doSetVolume(vol:Number):void
		{
			m_soundTransform.volume = vol;
			if (m_soundChannel)
			{
				m_soundChannel.soundTransform = m_soundTransform;
			}
		}
		
		protected function soundChannel_complete(e:Event):void
		{
			mediaReachedEnd();
		}
		
		protected function sound_id3(e:Event):void
		{
			log('--------------------- ID3 ---------------------');
			for (var key:String in m_sound.id3)
			{
				log(key + ' - ' + m_sound.id3[key]);
			}
			//m_duration = m_sound.id3.TIME;
			log(m_sound.id3.TIME);
			log('--------------------- /ID3 ---------------------');
		}
	}
}