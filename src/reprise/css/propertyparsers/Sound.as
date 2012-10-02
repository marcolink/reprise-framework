package reprise.css.propertyparsers
{

	import reprise.css.CSSParsingResult;
	import reprise.css.CSSPropertyParser;

	public class Sound extends CSSPropertyParser
	{
		//----------------------              Public Properties             ----------------------//
		public static const KNOWN_PROPERTIES : Object =
		{
			sound : {parser : parseSound},
			soundId : {parser : strToStringProperty},
			soundLoops : {parser : strToIntProperty},
			soundVolume : {parser : strToNumericProperty}
		};
		public static const SOUND_NONE : String = "none";


		//----------------------       Private / Protected Properties       ----------------------//


		//----------------------               Public Methods               ----------------------//
		public function Sound (){}


		//----------------------         Private / Protected Methods        ----------------------//
		private static function parseSound (
				val:String, selector : String, file:String) : CSSParsingResult
		{
			var res : CSSParsingResult = new CSSParsingResult();
			return res;
		}
	}
}