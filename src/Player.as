package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class Player extends Sprite
	{
		public var g:MovieClip 
		public var playerName:String
		public var main:Main
		public var health:Number 
		public var startHealth:Number	
	
		public var isJumping:Boolean = false
		public var vx:Number = 0
		public var vy:Number = 0
		
		//TODO: 5) skrew around with the speeed and stuff
		public var acc:Number = 6
		public var friction:Number = 3
		public var maxSpeed:Number = 10
		public var jumpPower:Number = 30
		public var gravity:Number = 2
		
		public var frameSet:FrameSet
		public var touchingFloor:Boolean =false
		public var state:String ="stop"
		public var currentFrame:int = 1
		public var AField:AttackField
		public static var RED_COLOR:ColorTransform = new ColorTransform(1,1,1,1,100)
		public static var DEFUALT:ColorTransform = new ColorTransform()
		public var oWidth:Number
		public var oHeight:Number
		public function Player(name:String, graphicClass:Class,frameSetClass:Class, startHealth:Number = 100):void {
			this.playerName = name
			g = new graphicClass
			addChild(g)
			oWidth = this.width
			oHeight = this.height
			this.frameSet = new frameSetClass
			this.startHealth = startHealth
			health = startHealth
			//this.frameSet = frameSet
			//this.graphics.beginFill(0)
			//this.graphics.drawCircle(0,0,5)
		}
		public function setMain(m:Main):void {
			main = m
		}
		public function move(dir:Number) {
			flipHorz(dir)
			vx += dir * acc
		}
		public function jump() {	
			if(touchingFloor){
				vy = -30
			}
		}
		public function attack() {
			var index:int = main.attackFields.indexOf(AField)
			if(index != -1)  main.attackFields.splice(index, 1)
			if(touchingFloor){
				var R:Rectangle = new Rectangle(x + oWidth * .5, y + oHeight * .5, oWidth*.4, oHeight * .5)
				if(g.scaleX == -1)R.x -= oWidth
				AField = new AttackField(R,10,this)
				main.attackFields.push(AField)
				this.state = "attacking"
				this.currentFrame = frameSet.attackStartFrame
			}else {
				var R:Rectangle = new Rectangle(x + oWidth * .5, y + oHeight * .5, oWidth * .5, oHeight)
				if(g.scaleX == -1)R.x -= oWidth
				AField = new AttackField(R,15,this)
				main.attackFields.push(AField)
				this.state = "diveKicking"
				this.currentFrame = frameSet.diveKickFrame
			}
			//trace(this.state)
		}
		 //TODO: 6C) Make a new function called taunt().
		//				Inside it you will need to write: this.state = "taunting"; this.currentFrame = frameSet.tauntStartFrame;
		
		public function flipHorz(dir:Number = -1) {	
			if(dir == -1){
				g.scaleX = -1
				g.x = oWidth
			}else {
				g.scaleX = 1
				g.x = 0
			}
		}
		
		public function containsRectangle(r:Rectangle):Boolean {
			var rect:Rectangle = getBounds(main.stage)
			//trace("SDFSD")
			if (rect.left > r.right) {
				return false	
			}
			if (rect.right < r.left) {
				return false
			}
			if (rect.bottom < r.top) {
				return false
			}
			if (rect.top > r.bottom) {
				return false
			}
			return true
		}
		
	}

}