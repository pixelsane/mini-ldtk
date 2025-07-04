// @Pixelsane

import "qa"
import "json"

errorPrefix = "LDTKError:"

globals.translateCoords = function(coords, levelHeight)
	newCoords = {} + coords
	newCoords.y = levelHeight - coords.y
	return newCoords
end function

matchObj = {"identifier": null, "id": null, "identifier": null, "__identifier": null, "uid": null, "iid": null, "defuid": null}

getAnyMatch = function(obj, mObj)
	matchIdentifier = false
	matchId = false
	matchUid = false
	matchIid = false
  matchDefuid = false
  matchDDIdentifier = false

  isMatching = function(key, value)
    if mObj[key] != null then
      return mObj[key] == value[key]
    end if
  end function
	
	for i in range(0, obj.len - 1)
    matchIdentifier = isMatching("identifier", obj[i])
    matchId = isMatching("id", obj[i])
    matchUid = isMatching("uid", obj[i])
    matchIid = isMatching("iid", obj[i])
    matchIid = isMatching("defuid", obj[i])
    matchIid = isMatching("__identifier", obj[i])
		
		cond = (matchIdentifier or matchId or matchUid or matchIid or matchDefuid)
		
		if cond then
			return obj[i]
		end if
	end for
end function

// classMethods (are only appended when needed, hence it does not exist in data.levels[] -- Nor should this be accessed directly)
LDtkProps = function
  return {"supersimple": false, "data":null}
end function

levelMethods = {}
layerMethods = {}
entityMethods = {}
tileMethods = {}

tileMethods.positionRaw = function
	x = self.px[0]
	y = self.px[1]
	return {"x": x, "y": y}
end function

tileMethods.position = function
	levelHeight = self.levelHeight
	posRaw = self.positionRaw
	return translateCoords(posRaw, levelHeight)
end function

entityMethods.positionRaw = function
	x = self.px[0]
	y = self.px[1]
	return {"x": x, "y": y}
end function

entityMethods.position = function
	levelHeight = self.levelHeight

	posRaw = self.positionRaw
	return translateCoords(posRaw, levelHeight)
end function

entityMethods.getAllFields = function
	return self.fieldInstances
end function

entityMethods.getField = function(identifier, defuid = null)
	allDefs = self.getAllFields

  toMatch = new matchObj
  toMatch.__identifier = identifier
  toMatch.defuid = defuid
	match = getAnyMatch(allDefs, toMatch)

  qa.assert(match != null,  errorPrefix + "getField (" + identifier + ", "+defuid+") " + "does not exist in Entity or is not a valid field")
  return match + entityMethods
end function

entityMethods.getFieldValue = function(identifier, defuid = null)
  return self.getField(identifier, defuid).__value
end function

layerMethods.name = function
	return self.identifier
end function

layerMethods.gridToIndex = function(x,y)
	width = self.__cWid
	index = y * width + x
	return index	
end function

layerMethods.getAllTilesRaw = function
	return self.gridTiles
end function


// minimicro converted for absolute pixel and sprite drawing within the minimicro coordinates
layerMethods.getAllTiles = function
  raw = self.getAllTilesRaw
  translated = []
  for tile in raw
    newTile = tile + {}
    newTile.px[1] = self.levelHeight - newTile.px[1]
    translated.push newTile
  end for
  
	return translated
end function

layerMethods.pushTilesToDisplay = function(disp)
  qa.assert(disp != null, errorPrefix + "Attempt to push tiles to display but no valid display provided")
  qa.assert(disp.mode == displayMode.tile, errorPrefix + "Attempt to push tiles to display but display provided is not a TileDisplay")

	for tile in self.getAllTiles
		x = tile.px[0] / self.__gridSize
		y = (tile.px[1] / self.__gridSize) - 1
		t = tile.t
		disp.setCell(x,y,t)
	end for
end function

// Optional shorthand, use if you don't need to manually define the config display
layerMethods.initTileDisplay = function(disp, scale = 1)
  disp.tileSetTileSize = self.__gridSize
  disp.cellSize = self.__gridSize * scale
end function

layerMethods.getIntGridAtRaw = function(x,y)
	width = self.__cWid
	index = y * width + x
	return self.intGridCsv[index]
end function

// Flips Y axis
layerMethods.getIntGridAt = function(x,y)
  height = self.__cHei
  width = self.__cWid
  if x < 0 or x >= width or y < 0 or y >= height then 
    return null 
  end if

  flippedY = (height - 1) - y
  index = flippedY * width + x
  return self.intGridCsv[index]
end function

layerMethods.indexToCoordsRaw = function(index)
  x = index % self.__cWid
  y = floor(index / self.__cWid)
  return {"x": x, "y": y}
end function

// Flipped Y
layerMethods.indexToCoords = function(index)
  x = index % self.__cWid
  y = floor(index / self.__cWid)
  flippedY = (self.__cHei - 1) - y
  return {"x": x, "y": flippedY}
end function

layerMethods.allIndexOfValue = function(value)
  stack = []
  for i in range(0, self.intGridCsv.len - 1)
    val = self.intGridCsv[i]
    if val == value then
      stack.push i
    end if
  end for
  return stack
end function

layerMethods.allCoordsOfValueRaw = function(value)
  indexes = self.allIndexOfValue(value)
  stack = []

  if indexes == [] then
    return []
  end if

  for i in range(0, indexes.len - 1)
    stack.push(self.indexToCoordsRaw(indexes[i]))
  end for
  return stack
end function


layerMethods.allCoordsOfValue = function(value)
  indexes = self.allIndexOfValue(value)
  stack = []

  if indexes == [] then
    return []
  end if

  for i in range(0, indexes.len - 1)
    stack.push(self.indexToCoords(indexes[i]))
  end for
  return stack
end function

// Append Int Grid to Obj to work with intGrids within a separate context. Helper methods will also be appended
layerMethods.appendIntGridToObj = function(obj)
  //qa.assertType()
  obj.intGridCsv = self.intGridCsv
  obj.__cHei = self.__cHei
  obj.__cWid = self.__cWid
  obj.indexToCoords = @layerMethods.indexToCoords
  obj.indexToCoordsRaw = @layerMethods.indexToCoordsRaw
  obj.at = @layerMethods.getIntGridAt
  obj.atRaw = @layerMethods.getIntGridAtRaw
  obj.allIndexOfValue = @layerMethods.allIndexOfValue
  obj.allCoordsOfValue = @layerMethods.allCoordsOfValue
  obj.allCoordsOfValueRaw = @layerMethods.allCoordsOfValueRaw
end function

levelMethods.getAllEntities = function
	entities = []
	for i in range(0, self.layerInstances.len - 1)
		layer = self.layerInstances[i]
		if layer.__type == "Entities" then
			for j in range(0, layer.entityInstances.len - 1)
				entities.push(layer.entityInstances[j])
			end for
		end if
	end for
	return entities
end function

levelMethods.getEntity = function(ddidentifier, iid = null, defuid = null)
	allEntities = self.getAllEntities
	levelHeight = self.pxHei

  toMatch = new matchObj
  toMatch.__identifier = ddidentifier
  toMatch.iid = iid
  toMatch.defuid = defuid
  match = getAnyMatch(allEntities, toMatch) + new entityMethods
  match.levelHeight = self.pxHei

  qa.assert(match != null,  errorPrefix + "getEntity (" + ddidentifier + ", "+ iid +") " + "does not exist in Level or is not a valid property")
  return match
end function

levelMethods.name = function
	return self.identifier
end function

levelMethods.position = function
	// Returns cartesian/minimicro coordinates
	levelHeight = self.pxHei
	x = self.worldX  
	y = levelHeight - self.worldY
	return {"x": x, "y": y}
end function

levelMethods.positionRaw = function
	// Returns raw position value as intended for LDtk/screen coordinates
	return {"x": self.worldX, "y": self.worldY}
end function

levelMethods.size = function
	return {"width": self.pxWid, "height": self.pxHei}
end function

levelMethods.gridSize = function
	gridSize = self.size
	return {"width": self.pxWid / gridSize.width, "height": self.pxHei / gridSize.height}
end function

levelMethods.getLayer = function(ddidentifier, iid=null)
  instances = self.layerInstances
  toMatch = new matchObj
  toMatch.__identifier = ddidentifier
  toMatch.iid = iid
  match = getAnyMatch(instances, toMatch)
  match.levelHeight = self.pxHei
  match.tilesetsPx = self.tilesetsPx

  qa.assert(match != null,  errorPrefix + "getLayer (" + ddidentifier + ", "+ iid +") " + "does not exist in Level or is not a valid property")
  return match + new layerMethods
end function

levelMethods.getIntGridAt = function(layerIdentifier,x,y)
	return self.getLayer(layerIdentifier).getIntGrid(x,y)
end function

// Main class
globals.LDtkProject = LDtkProps

assertLoaded = function(project)
	qa.assert(project.data != null, errorPrefix + " No valid LDtkProject loaded!")
end function


// Load a project first before anything else!
LDtkProject.loadFile = function(dir, supersimple = false)
	raw = file.open(dir)
	
	qa.assert((supersimple == false or supersimple == true), "Provided supersimple value: (" + supersimple + ") is not a valid value, please pass a boolean!")
	qa.assert(not(raw isa string), errorPrefix + dir + " does not exist or cannot be found!")
	parsed = json.parse(raw.read)
	raw.close
	
	self.data = parsed
	return self
end function

LDtkProject.getAllLevels = function
	assertLoaded self
	return self.data.levels
end function

LDtkProject.getLevel = function(identifier, iid=null, uid=null)
	assertLoaded self
	allLevels = self.getAllLevels

  toMatch = new matchObj
  toMatch.identifier = identifier
  toMatch.iid = iid
  toMatch.uid = uid
  match = getAnyMatch(allLevels, toMatch)
  // shove to function attachTilesetsPx
  match.tilesetsPx = {}
  for tileset in self.data.defs.tilesets
    match.tilesetsPx[tileset.uid] = {"pxWid": tileset.pxWid, "pxHei": tileset.pxHei}
  end for

  qa.assert(match != null,  errorPrefix + "getLevel (" + identifier + ", "+ iid +") " + "does not exist in Level or is not a valid property")
  return match + new levelMethods
end function

LDtkProject.getAllTilesets = function
	assertLoaded self
	return self.data.defs.tilesets
end function

LDtkProject.getTileset = function(identifier, uid=null)
	assertLoaded self
	isExisting = false
	allTilesets = self.getAllTilesets

  toMatch = new matchObj
  toMatch.identifier = identifier
  toMatch.uid = uid
  match = getAnyMatch(allTilesets, toMatch)

  qa.assert(match != null,  errorPrefix + "getTileset (" + identifier + ", "+ uid +") " + "does not exist in Project or is not a valid property")
  return match + new tileMethods
end function

// Convenient shorthand for layerMethods.pushTilesToDisplay
LDtkProject.pushTilesToDisplay = function(levelIdentifier, layerIdentifier, disp)
  self.getLevel(levelIdentifier).getLayer(layerIdentifier).pushTilesToDisplay(disp)
end function

LDtkProject.getAllEnums = function
	assertLoaded self
	return self.data.defs.enums
end function

LDtkProject.getEnum = function(identifier, uid=null)
	assertLoaded self
	allEnums = self.getAllEnums

  toMatch = new matchObj
  toMatch.identifier = identifier
  toMatch.uid = uid
  match = getAnyMatch(allEnums, toMatch)

  qa.assert(match != null,  errorPrefix + "getEnum (" + identifier + ", "+defuid+") " + "does not exist in Level or is not a valid property")
  return match
end function

LDtkProject.getEnumValue = function(id, enumIdentifier, enumUid=false)
	assertLoaded self
	enum = self.getEnum(enumIdentifier, enumUid)
	values = enum.values
	
	for i in range(0, values.len - 1)
		if values[i].id == id then
			return values[i]
		end if
	end for
end function

LDtkProject.defaultGridSize = function
	assertLoaded self
	return self.data.defs.defaultGridSize
end function

LDtkProject.levelSize = function(identifier, id=null, iid=null)
	assertLoaded self
	level = self.getLevel(identifier, id, iid)
	return level.size
end function
