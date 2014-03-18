package  
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class AttackField 
	{
		public var rect:Rectangle = new Rectangle
		public var dmg:Number
		public var master:Player
		public function AttackField(rect:Rectangle, dmg:Number, master:Player):void {
			this.rect = rect
			this.dmg = dmg
			this.master = master
		}
		//public function hasContactWithRect(R:Rectangle):Boolean {
			//return rect.contains(
		//}
		
	}

}