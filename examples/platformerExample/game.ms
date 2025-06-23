// Open up jamVersion.LDtk, to learn more about my current setup

import "../mini-ldtk/LDtk"
import "qa"
import "spriteCon"

clear

// Alias
newAnimation = @spriteCon.newAnimation
Platformer = @spriteCon.Platformer

// Remember
dataDir = "./data/"
gameState = {"currentLevel": 0, "levelNames": ["Sample", "Sample2"]}
jam = new LDtkProject
jam.loadFile dataDir + "jamVersion.ldtk"
bg = file.loadImage("./assets/background.png")


// Display Stuff
display(4).mode = displayMode.sprite
display(5).mode = displayMode.tile
display(6).mode = displayMode.pixel
display(6).drawImage bg
dispScale = 2

TILE_DISP = display(5)
TILE_DISP.tileSet = file.loadImage("./assets/tileset.png")
TILE_DISP.tileSetTileSize = 16
TILE_DISP.cellSize = 16 * dispScale
TILE_DISP.extent = [30, 20]
TILE_DISP.clear

SPRITE_DISP = display(4)
SPRITE_DISP.clear

render = function(ent)
	ent.spr.scale = dispScale
	SPRITE_DISP.sprites.push ent.spr
end function

currentLevelName = function
	levelName = gameState.levelNames[gameState.currentLevel]
	return levelName
end function

// loads all the necessary frameset from LDtk fields
// then assigns them on the appropriate sprites
loadFramesets = function(ent, LDtkent, animName, framesetName)
	frameset = []
	LDtkFrameset = LDtkent.getFieldValue(framesetName)
	for png in LDtkFrameset
		frameset.push(file.loadImage(png))
	end for
	
	ent.spr[animName] = newAnimation(frameset)
end function

// gets all the needed data from LDtk with a single function
addFromLDtk = function(name, LDtkProj)
	
	newEnt = {}
	newEnt.name = name
	newEnt.spr = new Platformer
	newEnt.spr.normalScale = [dispScale, dispScale]
	newEnt.spr.flippedScale = [-dispScale, dispScale]	
	
	LDtkEnt = LDtkProj.getEntity(name)
	
	spriteSize = LDtkEnt.getFieldValue("spriteSize")
	defaultPos = LDtkEnt.position
	
	defaultPos.x *= dispScale
	defaultPos.y *= dispScale
	defaultPos.x += spriteSize[0]
	defaultPos.y += spriteSize[1]
	
	newEnt.spr.runSpeed = LDtkEnt.getFieldValue("runSpeed")
	newEnt.spr.runAccel = LDtkEnt.getFieldValue("runAccel")
	newEnt.spr.stopAccel = LDtkEnt.getFieldValue("stopAccel")
	newEnt.spr.climbSpeed = LDtkEnt.getFieldValue("climbSpeed")
	newEnt.spr.jumpSpeed = LDtkEnt.getFieldValue("jumpSpeed")
	newEnt.spr.gravity = LDtkEnt.getFieldValue("gravity")
	newEnt.spr.boost = LDtkEnt.getFieldValue("boost")
	newEnt.spr.flyAccel = LDtkEnt.getFieldValue("flyAccel")
	
	loadFramesets(newEnt, LDtkEnt, "idleAnim", "idleFrameset")
	loadFramesets(newEnt, LDtkEnt, "runAnim", "runFrameset")
	loadFramesets(newEnt, LDtkEnt, "jumpUpAnim", "jumpFrameset")
	
	newEnt.spr.x = defaultPos.x
	newEnt.spr.y = defaultPos.y
	return newEnt
end function

// Main usage
level = jam.getLevel("Sample")
collisionLayer = level.getLayer("Collisions")
envLayer = level.getLayer("Environment")
CRT = addFromLDtk("CRT", level)

collisionLayer.appendIntGridToObj CRT.spr
envLayer.pushTilesToDisplay TILE_DISP
render CRT

loop = function
	lastTime = time
	while not key.pressed("escape")	
		dt = time - lastTime
		lastTime = time
		spriteCon.updateSprites dt
		yield
	end while
	key.clear
end function

loop