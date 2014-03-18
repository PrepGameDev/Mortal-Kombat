package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Danny Weitekamp
	 */
	public class Main extends Sprite 
	{
		//TODO: 1)  Change how the characters look in Flash Pro.  Be sure to remember to repackage them (CTRL+ENTER)
		//			-Note: Characters have multiple frames. Check the timeline.
		//TODO: 2A)  Draw a background in FLash Pro. Export it for actionscript and be sure to remember to package it (CTRL+ENTER)
		//TODO: 6A) Create a taunt action. Fist draw your taunt animation at the end of the timeline for your character.  Be sure to remember to package it (CTRL+ENTER)
		
		public var backgroundCanvas:Sprite = new Sprite
		public var playerCanvas:Sprite = new Sprite
		public var GUI_Canvas:Sprite = new Sprite
		public var players:Vector.<Player> = new Vector.<Player>
		public var attackFields:Vector.<AttackField> = new Vector.<AttackField>
		public var player1:Player
		public var player2:Player
		public var isDown:Dictionary = new Dictionary
		public var p1Health:Sprite = new Sprite
		public var p2Health:Sprite = new Sprite
		public var endText:TextField = new TextField
		public var difficultyText:TextField = new TextField
		public function Main():void 
		{
			init()			
			reset()
			
			//TODO: 2B)  Add your new background to the backgroundCanvas
			// 			-Hint: you need to create a new sprite so:  var mySprite:Sprite = new WhatEverYouCalledYourBackground  
			//					then you need to add it to the backgroundCanvas:   backgroundCanvas.addChild(mySprite) 
			
		}
		public function reset():void {
			var difficulty:String = AI.EASY
			if (player2 !=null &&  player2 is AI) {
				var difficulty:String = AI(player2).difficulty
			}
			while(players.length != 0){
				removePlayer(players[0])
			}
			//TODO: 7)Change the starting health... its the last parameter in the Player constructor
			player1 = new Player("player1", BlondePlayer, FrameSet, 100)
			//TODO: 9A)	Make player2 another person
			//			First make player2 a Player like player1 instead of an AI
			player2 = new AI(player1,"player2", RedPlayer , FrameSet,100)
			player2.flipHorz()
			player2.x = 500//stage.stageWidth+20
			addPlayer(player1)
			addPlayer(player2)
			
			if (player2 is AI) {
				AI(player2).setDifficulty(difficulty)
				difficultyText.text = "DIFFICULTY: " + AI(player2).difficulty
			}
			while(attackFields.length != 0){
				attackFields.splice(0,1)
			}
		}
		
		public function init():void {
			var eT:TextField = new TextField
			GUI_Canvas.addChild(eT)
			eT.text = "Press Enter to Reset. 1,2,3 to change difficulty"
			eT.width = 400
			
			//TODO: 8)	Make some textFields to go above the health bars to denote which bar belongs to which player (i.e player1, player2)
			//			There are two ways to go about this, either define the text fields locally like eT above, or create public variables
			//			to store them so you can change them dynamically
			//			You are going to have to do some guess work to get them centered where you want them (remember in flash the origin
			//			is in the top left corner. Larger Y's put objects lower on the screen)
			
			difficultyText = new TextField
			GUI_Canvas.addChild(difficultyText)
			difficultyText.y = 15
			
			
			p1Health.graphics.beginFill(0xFF0000, .75)
			p1Health.graphics.drawRect(0, 0, 200, 20)
			p1Health.x = 100
			p1Health.y = 50
			
			p2Health.graphics.beginFill(0xFF0000, .75)
			p2Health.graphics.drawRect(0, 0, 200, 20)
			
			p2Health.x = 500
			p2Health.y = 50
			
			endText.text = "VS"
			endText.x = 350
			endText.y = 30
			
			endText.scaleX = 5
			endText.scaleY = 5
			
			GUI_Canvas.addChild(p1Health)
			GUI_Canvas.addChild(p2Health)
			GUI_Canvas.addChild(endText)
			
			
			stage.addChild(backgroundCanvas)
			stage.addChild(playerCanvas)
			stage.addChild(GUI_Canvas)
			stage.addEventListener(Event.ENTER_FRAME, loop)
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown)
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp)
		}
		
		public function addPlayer(p:Player):void {
			playerCanvas.addChild(p)
			players.push(p)
			p.setMain(this)
		}
		public function removePlayer(p:Player):void {
			playerCanvas.removeChild(p)
			players.splice(players.indexOf(p),1)
			
		}
		
		public function loop(e:Event):void {
			if (player2.health <= 0) {
				endText.text = "WIN!"
				return
			}
			if (player1.health <= 0) {
				endText.text = "LOSE :("
				return
			}
			
			
			//trace(player1.state)
			//TODO: 9C) Now make whatever keys you want to correspond to left and right keys for the second player (perhaps 4 and 6
			//			on the numpad).You are going to need to duplicate this whole else-if-else clause below and change the keys and player.
			//			If you don't know the ASCII code forthe key you want to use just press it and check what
			//			it traces out. Otherwise you can consult the internet.
			//			If you did everything correctly you should be able to play 1v1 with your friends on the same keyboard
			
			
			if (keyIsPressed(65)) {
				player1.move( -1)
				
				if (player1.state == "stop") {
					player1.state = "walking"
				}
			}else if (keyIsPressed(68)) {
				player1.move(1)	
				//player1.flipHorz(1)
				if (player1.state == "stop") {
					player1.state = "walking"
				}
			}else {
				if (player1.state == "walking") {
					player1.state = "stop"
				}
			}
			//trace(player1.state)
			for (var i:int = 0; i < players.length; i++) {
				var p:Player = players[i];
				
				if (p is AI) {
					AI(p).think()
				}
				
				p.g.transform.colorTransform =Player.DEFUALT
				
				p.vy += p.gravity
				p.x += p.vx
				p.y += p.vy
				if ((p.vx - p.friction) * p.vx < 1) {
					p.vx = 0
				}else {
					if(p.vx < 0){
						p.vx += p.friction
					}else {
						p.vx -= p.friction
					}
				}
				
				//if(p.vy < -p.maxSpeed)p.vy = -p.maxSpeed
				//if (p.vy > p.maxSpeed) p.vy = p.maxSpeed
				if(p.vx < -p.maxSpeed)p.vx = -p.maxSpeed
				if(p.vx > p.maxSpeed)p.vx = p.maxSpeed
				var g:Sprite = p.g
				var R:Rectangle = p.g.getRect(stage)
				if (R.bottom > stage.stageHeight) {
					p.y -= R.bottom - stage.stageHeight
					p.vy = 0
					p.touchingFloor = true
				}else {
					p.touchingFloor = false
				}
				if (p.x < 0) {
					p.x = 0
					p.vx = 0
					if(p is AI) AI(p).retreat = ! AI(p).retreat
				}
				if (p.x+p.oWidth > stage.stageWidth) {
					p.x -=(p.x+p.oWidth) - stage.stageWidth
					p.vx = 0
					if(p is AI) AI(p).retreat = ! AI(p).retreat
				}
				
				for (var j:int = 0; j < attackFields.length; j++) {
					var field:AttackField = attackFields[j]
					if (field.master != p) {
						if(p.containsRectangle(field.rect)){
							p.health -= field.dmg
							p.g.transform.colorTransform = Player.RED_COLOR
							attackFields.splice(j, 1)
							j--
							trace("RED")
						}
					}
				}
				
				if (p.state == "stop") {
					p.currentFrame = p.frameSet.stopFrame
				}else if (p.state == "walking") {
					p.currentFrame++
					if (p.currentFrame < p.frameSet.walkStartFrame || p.currentFrame > p.frameSet.walkStopFrame) {
						p.currentFrame = p.frameSet.walkStartFrame
					}					 //= p.frameSet.stopFrame
				}else if (p.state == "attacking") {
					p.currentFrame++
					if (p.currentFrame > p.frameSet.attackStopFrame) {
						p.state = "stop"
						p.currentFrame = p.frameSet.stopFrame
						var index:int = attackFields.indexOf(p.AField)
						if(index != -1) attackFields.splice(index, 1)
					}
					
				}else if (p.state == "diveKicking") {
						//TODO: 3)  Skrew with the direction of the diveKick
						//			-Hint right now its displacement perFrame is a vector with components (25,25)
					p.vx = p.g.scaleX * 25
					p.vy = 25
				
			// 			
					p.AField.rect.x = p.x + p.width * .5
					p.AField.rect.y = p.y + p.height * .5
					if(p.touchingFloor || attackFields.indexOf(p.AField) == -1){
						p.state = "stop"
						p.currentFrame = p.frameSet.stopFrame
						var index:int = attackFields.indexOf(p.AField)
						if(index != -1) attackFields.splice(index, 1)
					}
				}
				 //TODO: 6D) append  else if(p.state == "taunting"){ to the end of the block above
				 //			inside the new block we will need almost the same code as for the "attacking" block
				 //			the only difference is that we will be comparing p.current frame to p.frameSet.tauntStopFrame in the if satement
				
				p.g.gotoAndStop(p.currentFrame)
			}
			
		
			p1Health.scaleX = player1.health/player1.startHealth
			p2Health.scaleX = player2.health / player2.startHealth
			//trace(player1.health, player2.health)
			//trace(player1.vx)
		}
		public function keyIsPressed(n:int):Boolean {
			if (isDown[n] != null && isDown[n]) {
				return true
			}
			return false
		}
		public function keyDown(e:KeyboardEvent):void {
			trace(e.keyCode)
			 
			
			if (!keyIsPressed(13) && e.keyCode == 13) {
				reset()
			}
			if ( e.keyCode == 49) {
				if (player2 is AI) {
					AI(player2).setDifficulty(AI.EASY)
					if(player2 is AI)difficultyText.text = "DIFFICULTY: " + AI(player2).difficulty
				}
			}
			if (e.keyCode == 50) {
				if (player2 is AI) {
					AI(player2).setDifficulty(AI.MEDIUM)
					if(player2 is AI)difficultyText.text = "DIFFICULTY: " + AI(player2).difficulty
				}
			}
			if ( e.keyCode == 51) {
				if (player2 is AI) {
					AI(player2).setDifficulty(AI.HARD)
					if(player2 is AI)difficultyText.text = "DIFFICULTY: " + AI(player2).difficulty
				}
			}
			
			//TODO: 6E) Now pick your favorite key and make it call your new taunt() function. If you don't know the ASCII code for
			//			the key you want to use just press it and check what it traces out. Otherwise you can consult the internet.
			if (!keyIsPressed(87) && e.keyCode == 87) {
				player1.jump()
			}
			if (!keyIsPressed(32) && e.keyCode == 32) {
				player1.attack()
			}
			//TODO: 9B) Now make whatever keys you want to correspond to jump and attack keys for the second player (perhaps 8 and 0
			//			on the numpad).If you don't know the ASCII code for	the key you want to use just press it and check what
			//			it traces out. Otherwise you can consult the internet.
			isDown[e.keyCode] = true
		}
		public function keyUp(e:KeyboardEvent):void {
			//trace(e.keyCode)
			isDown[e.keyCode] = false
		
		}
		
		
	}
	
}