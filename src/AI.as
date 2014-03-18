package  
{
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class AI extends Player
	{
		var target:Player
		public var retreat:Boolean = false
		public static var EASY:String = "easy"
		public static var MEDIUM:String = "medium"
		public static var HARD:String = "hard"
		protected var jumpChance:Number 
		protected var attackChance:Number 
		protected var chageDirChance:Number 
		public var difficulty:String
		public function AI(target:Player, name:String, graphicClass:Class,frameSetClass:Class, startHealth:Number = 100) 
		{
			super(name, graphicClass,frameSetClass, startHealth)
			this.target = target
			setDifficulty(EASY)
		}
		
		public function think():void {
			if (Math.random() < chageDirChance) retreat = !retreat
			
			if (retreat) {
				move(1)
			}else {
				move(-1)
			}
			var rand:Number = Math.random()
			if (rand < attackChance) {
				attack()
			}else if(rand < attackChance+jumpChance){
				jump()
			}
			
		}
		public function setDifficulty(d:String):void {
			//TODO: 4)  Skrew around with the difficulty of the AI
			if (d == EASY) {
				attackChance = .05
				jumpChance = .025
				chageDirChance= .01
			}
			if (d == MEDIUM) {
				attackChance = .2
				jumpChance = .075
				chageDirChance= .01
			}
			if (d == HARD) {
				attackChance = .4
				jumpChance = .1
				chageDirChance= .01
			}
			difficulty = d
		}
		
	}

}