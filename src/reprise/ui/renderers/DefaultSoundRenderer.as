package reprise.ui.renderers
{

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	import reprise.css.propertyparsers.Sound;
	import reprise.events.ResourceEvent;
	import reprise.external.MP3Resource;

	public class DefaultSoundRenderer extends AbstractCSSRenderer
	{
		private var _soundLoader : MP3Resource;
		private var _sound : flash.media.Sound;
		private var _channel : SoundChannel;
		//----------------------              Public Properties             ----------------------//


		//----------------------       Private / Protected Properties       ----------------------//


		//----------------------               Public Methods               ----------------------//
		public function DefaultSoundRenderer () {}

		public override function draw() : void
		{
			if (m_styles.soundId != reprise.css.propertyparsers.Sound.SOUND_NONE)
			{
				if(!_channel)
				{
					loadSound();
				}
			}
		}


		public override function destroy() : void
		{
			if (_soundLoader)
			{
				_soundLoader.cancel();
				_soundLoader.removeEventListener(Event.COMPLETE, soundLoader_complete);
				_soundLoader = null;
			}

			if(_sound)
			{
				_sound.close();
				_sound = null;
			}
		}

		//----------------------         Private / Protected Methods        ----------------------//
		protected function loadSound () : void
		{
			if (_soundLoader && _soundLoader.isExecuting())
			{
				destroy();
			}

			_soundLoader = new MP3Resource();
			_soundLoader.setURL(m_styles.soundId);
			_soundLoader.addEventListener(Event.COMPLETE, soundLoader_complete);
			_soundLoader.execute();
		}

		private function soundLoader_complete (event : ResourceEvent = null) : void
		{
			if (!event.success || m_styles.soundId == null ||
					m_styles.soundId == reprise.css.propertyparsers.Sound.SOUND_NONE)
			{
				clearSound();
				return;
			}
			_sound = _soundLoader.content();
			_channel = _sound.play(m_styles.soundDelay || 0, m_styles.soundLoops || 0);
			_channel.addEventListener(Event.SOUND_COMPLETE, sound_complete);
		}

		private function sound_complete (event : Event) : void
		{
			_channel = null;
			clearSound();
		}

		private function clearSound () : void
		{
			if(_sound)
			{
				_sound.close();
			}
		}
	}
}