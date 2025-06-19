# Mini-LDtk Documentation
> v0.1

## Table of Contents

- [Setup and Extended Examples](#setup-and-extended-examples)
- [Accessing Raw LDtk Data](#accessing-raw-ldtk-data)
- [Global and Helpers](#global-and-helpers)
  - [translateCoords](#translatecoordscords-levelheight)
- [LDtkProject](#ldtkproject-methods)
  - [loadFile](#ldtkprojectloadfiledir-supersimple--false)
  - [getAllLevels](#ldtkprojectgetalllevels)
  - [getLevel](#ldtkprojectgetlevelidentifier-iid--null-uid--null)
  - [getAllTilesets](#ldtkprojectgetalltilesets)
  - [getTileset](#ldtkprojectgettilesetidentifier-uid--null)
  - [pushTilesToDisplay](#ldtkprojectpushtilestodisplaylevelidentifier-layeridentifier-disp)
  - [getAllEnums](#ldtkprojectgetallenums)
  - [getEnum](#ldtkprojectgetenumidentifier-uid--null)
  - [getEnumValue](#ldtkprojectgetenumvalueid-enumidentifier-enumuid--false)
  - [defaultGridSize](#ldtkprojectdefaultgridsize)
  - [levelSize](#ldtkprojectlevelsizeidentifier-id--null-iid--null)
- [Layer](#layermethods)
  - [name](#layermethodsname)
  - [gridToIndex](#layermethodsgridtoindexx-y)
  - [getAllTiles](#layermethodsgetalltiles)
  - [pushTilesToDisplay](#layermethodspushtilestodisplaydisp)
  - [initTileDisplay](#layermethodsinittiledisplaydisp-scale--1)
  - [getIntGridAt](#layermethodsgetintgridatx-y)
  - [indexToCoords](#layerindextocoordsindex)
  - [indexToCoordsRaw](#layerindextocoordsrawindex)
  - [allIndexOfValue](#layerallindexofvaluevalue)
  - [allCoordsOfValueRaw](#layerallcoordsofvaluerawvalue)
  - [allCoordsOfValue](#layerallcoordsofvaluevalue)
  - [appendIntGridToObj](#layerappendintgridtoobjobj)
- [Level](#levelmethods)
  - [getAllEntities](#levelmethodsgetallentities)
  - [getEntity](#levelmethodsgetentityidentifier-iid--null)
  - [name](#levelmethodsname)
  - [position](#levelmethodsposition)
  - [positionRaw](#levelpositionraw)
  - [size](#levelmethodssize)
  - [gridSize](#levelmethodsgridsize)
  - [getLayer](#levelmethodsgetlayeridentifier-iid--null)
  - [getIntGridAtRaw](#levelmethodsgetintgridatrawlayeridentifier-x-y)
  - [getIntGridAt](#levelmethodsgetintgridatlayeridentifier-x-y)
- [Entity](#entitymethods)
  - [positionRaw](#entitypositionraw)
  - [position](#entityposition)
  - [getAllFields](#entitygetallfields)
  - [getField](#entitygetfieldidentifier-defuid--null)
  - [getFieldValue](#entitygetfieldvalueidentifier-defuid--null)
- [Tile](#tile-methods-tilemethods)
  - [positionRaw](#tilepositionraw)
  - [position](#tileposition)

---

### Known Limitations / In The Near Future

- No built-in support yet for LDtk layers with auto-layer rules.
- No built-in support for level/world transitions — recommended to manually manage world navigation logic in your game loop.

> However all properties are accessible and in combination with convenient helpers, implementations becomes easy. Contributions are welcome!

---

## Setup and Extended Examples
```python
// Ensure project is loaded
project = new LDtkProject
project.loadFile("res/world.ldtk")

level = project.getLevel("Level_1")
player = level.getEntity("Player")

// Get the layers from Level
collisionLayer = level.getLayer("Collision")
environmentLayer = level.getLayer("Environment")
furnitureLayer = level.getLayer("Furnitures")

// You can also append Int Grid to a map/object and access helper functions that way
house = {}
furnitureLayer.appendIntGridToObj house
house.chairs = house.allCoordsOfValue(1)
house.desks = house.allCoordsOfValue(2)

// Convenient single function to directly send tiles to to display
display(5).mode = displayMode.tile
display(5).tileSet = file.loadImage("/usr/tilesets/environment.png")

environmentLayer.initTileDisplay display(5)
environmentLayer.pushTilesToDisplay display(5)

furnitureLayer.initTileDisplay display(5)
furnitureLayer.pushTilesToDisplay display(5)

// Ex: Bounds checking using IntGrid
isWall = collisionLayer.getIntGridAt(10, 5) == 1

pprint "Player at: " + player.x + ", " + player.y
```

## Accessing Raw LDtk Data
```python
  // Raw LDtk/JSON data can be found in
  raw = LDtkProject.data

  // Access
  raw.levels[0]
  raw.defs.layers
  raw.defs.entities

  // Also all expected nested data exists in every get methods
  firstLevel = raw.getLevel("Level_1")
  enemies = firstLevel.getLayer("Enemies")

  firstLevel.worldX
  firstLevel.__bgColor

  enemies.__opacity
  enemies.visible
  enemies.optionalRules
    
```
## Global and Helpers
### `translateCoords(coords, levelHeight)`

Converts a coordinate map between **LDtk (top-down)** and **MiniMicro/Cartesian (bottom-up)** systems.

#### Parameters:
- `coords`: A coordinate map containing `{x, y}`
- `levelHeight`: The height of the level in pixels

#### Returns:
A new `{x, y}` map with Y-axis flipped or adjusted.

#### Example:
```python
ldtkPos = {"x": 100, "y": 120}
worldPos = translateCoords(ldtkPos, 240)
```

> This is helpful for placing objects correctly when LDtk and your minimicro disagree on coordinate orientation.

---

## LDtkProject Methods

### `LDtkProject.loadFile(dir, supersimple = false)`
Loads an LDtk file from the given directory. supersimple not yet implemented.

```python
project = new LDtkProject
project.loadFile("game/levels.ldtk", true)
```

---

### `LDtkProject.getAllLevels`
Returns a list of all levels.

```python
for level in project.getAllLevels
  pprint level.name
end
```

---

### `LDtkProject.getLevel(identifier, iid = null, uid = null)`
Returns a level by its identifier, `iid`, or `uid`.

```python
level = project.getLevel("Level_1")
```

---

### `LDtkProject.getAllTilesets`
Returns all tilesets.

---

### `LDtkProject.getTileset(identifier, uid = null)`
Returns a tileset by identifier or UID.

---

### `LDtkProject.pushTilesToDisplay(levelIdentifier, layerIdentifier, disp)`

Convenient global helper. Grabs the specified level and layer, then calls `pushTilesToDisplay`.

```python
project.pushTilesToDisplay("Sample", "Environment", TILE_DISP)
```

---

### `LDtkProject.getAllEnums`
Returns all enum definitions.

---

### `LDtkProject.getEnum(identifier, uid = null)`
Returns enum by name or UID.

---

### `LDtkProject.getEnumValue(id, enumIdentifier, enumUid = false)`
Returns a specific enum value by its ID and enum name or UID.

---

### `LDtkProject.defaultGridSize`
Returns the project's default grid size.

---

### `LDtkProject.levelSize(identifier, id = null, iid = null)`
Returns size of the specified level.

```python
size = project.levelSize("Level_1")
ppprint [size.width, size.height]
```

---

## LayerMethods

### `layer.name`
Returns the name of the layer.

```python
pprint layer.name --> "Collision"
```

---

### `layer.gridToIndex(x, y)`
Converts grid coordinates `(x, y)` into a 1D array index.

```python
index = layer.gridToIndex(3, 5)
```

---

### `layer.getAllTiles`
Returns a list of all tiles in the layer.

```python
for tile in layer.getAllTiles
  x = tile.x
  y = tile.y
  id = tile.tileId
end
```

---

### `layer.pushTilesToDisplay(disp)`

Pushes all the tiles from this layer to a given `TileDisplay`.

```python
layer = level.getLayer("Environment")
layer.pushTilesToDisplay(TILE_DISP)
```

> The target `disp` must be a valid TileDisplay and an image tileset must be loaded.

---

### `layer.initTileDisplay(disp, scale = 1)`

Initializes a `TileDisplay` to match the tile size of this LDtk layer.

This is a **convenient helper** for setting up a MiniMicro `TileDisplay` with the correct `tileSetTileSize` and `cellSize` based on the LDtk layer's grid size.

---

### `layer.getIntGridAt(x, y)`

Returns the int grid value at the specified `(x, y)` position.

```python
if layer.getIntGridAt(10, 12) == 1 then
  pprint "Wall here!"
end
```

---

### `layer.indexToCoords(index)`

Returns **flipped Y** coordinates suitable for cartesian or MiniMicro (bottom-left origin).

```python
coords = layer.indexToCoords(42)  // {x: 10, y: 11}
```

---

### `layer.indexToCoordsRaw(index)`

Returns the raw LDtk-style coordinates (top-left origin) for an IntGrid cell index.

```python
coords = layer.indexToCoordsRaw(42)  // {x: 10, y: 4}
```

---

### `layer.allIndexOfValue(value)`

Returns a list of all indices in the IntGrid where the cell equals the specified value.

```python
indices = layer.allIndexOfValue(3)  // [5, 20, 33, 87, ...]
```

---

### `layer.allCoordsOfValueRaw(value)`

Returns all raw LDtk-style coordinates where the IntGrid cell equals `value`.

```python
coords = layer.allCoordsOfValueRaw(1)
// [{x: 3, y: 2}, {x: 10, y: 6}, ...]
```

---

### `layer.allCoordsOfValue(value)`

Returns all flipped/cartesian-style coordinates where the IntGrid cell equals `value`.

```python
coords = layer.allCoordsOfValue(2)
// [{x: 1, y: 13}, {x: 8, y: 7}, ...]
```

---

### `layer.appendIntGridToObj(obj)`

Appends the layer’s IntGrid data and helper methods to a separate object.

This is useful when you want to extract a layer’s IntGrid logic for sandboxing or transformations.

```python
obj = {}
layer.appendIntGridToObj(obj)

val = obj.at(5, 3)
coords = obj.allCoordsOfValue(2)
```

> The object will get a copy of the IntGrid CSV and a copy of the helper functions.

All helper functions appended:

```python
obj.indexToCoords(index)
obj.indexToCoordsRaw(index)
obj.at(x, y)        // alias of getIntGridAt (MiniMicro)
obj.atRaw(x, y)     // alias of getIntGridAtRaw
obj.allIndexOfValue(value)
obj.allCoordsOfValue(value)
obj.allCoordsOfValueRaw(value)
```

---


## levelMethods

### `level.getAllEntities`
Returns all entities in the level.

```python
for ent in level.getAllEntities
  pprint ent.identifier
  pprint [ent.x, ent.y]
end
```

---

### `level.getEntity(identifier, iid = null)`
Returns the first matching entity by identifier or `iid`.

```python
player = level.getEntity("Player")
```

---

### `level.name`
Returns the level name.

```python
pprint level.name --> "Level_1"
```

---

### `level.position`

Returns the level's **position in Cartesian/MiniMicro coordinates**, where Y increases upward.

This is useful for rendering in environments where the origin is bottom-left, such as MiniMicro.

```python
pos = level.position
print(pos.x, pos.y)
```

> Internally, this subtracts the LDtk Y-coordinate from the level height.

---

### `level.positionRaw`

Returns the level's **raw LDtk position**, exactly as it appears in the `.ldtk` file. In LDtk, the origin is top-left.

```python
rawPos = level.positionRaw
print(rawPos.x, rawPos.y)
```

> Use this if you need to work in screen-space or match LDtk’s layout directly.

---

### `level.size`
Returns the size of the level in pixels.

```python
sz = level.size
// output: {sz.width, sz.height}
```

---

### `level.gridSize`
Returns the grid dimensions of the level.

```python
grid = level.gridSize 
// output: {"width": 20, "height": 30}
```

---

### `level.getLayer(identifier, iid = null)`
Returns a specific layer by its identifier or `iid`.

```python
collision = level.getLayer("Collision")
```

---

### `level.getIntGridAtRaw(layerIdentifier, x, y)`
Returns the int grid value at `(x, y)` for the specified layer. (Top-left origin, same as LDtk)

```python
if level.getIntGridAt("Collision", 5, 5) > 0 then
  pprint("Blocked!")
end
```
---

### `level.getIntGridAt(layerIdentifier, x, y)`
Returns the int grid value at `(x, y)` for the specified layer. (Uses bottom-left origin same as MiniMicro Tiles)

```python
if level.getIntGridAt("Collision", 5, 5) > 0 then
  pprint("Blocked!")
end
```
---

## entityMethods

### `entity.positionRaw`

Returns the **raw position of the entity**, as stored in LDtk. This reflects the pixel position from the top-left corner (LDtk screen space).

```python
pos = entity.positionRaw
pprint pos
// output: {x: int, y: int}
```

> Use this when working directly with LDtk's coordinate space or tile-aligned rendering.

---

### `entity.position`

Returns the **converted position** of the entity in Cartesian or MiniMicro coordinates, where the Y-axis increases upwards.

> This uses `translateCoords` internally and requires the entity’s `levelHeight` to be defined (automatically set when parsing through levels).

```python
pos = entity.position
pprint pos
// output: {x: int, y: int}
```
---

### `entity.getAllFields`

Returns a list of **all field instances** on this entity.

```python
fields = entity.getAllFields
for field in fields
    pprint field.__identifier
    pprint field.__value
end for

> Each field instance is a map with metadata like `__identifier`, `__type`, and `__value`.
```

---

### `entity.getField(identifier, defuid = null)`

Returns the **raw field object** matching the given field name (`identifier`). You can optionally pass the `defuid` if needed to disambiguate multiple field definitions with the same name.

```python
field = entity.getField("Speed")
field.__type
field.__value
```

---

### `entity.getFieldValue(identifier, defuid = null)`

Returns only the **value** of the field.

```python
speed = entity.getFieldValue("Speed")
pprint("Speed is: " + speed)
```

---

## tileMethods

### `tile.positionRaw`

Returns the **raw position of the tile** in pixels, based on LDtk's coordinate system (top-left origin).

```python
pos = tile.positionRaw
// output: pos = {"x": 0, "y": 0}
```

> Use this for working with LDtk-native layouts or matching tiles directly to visual assets.

---

### `tile.position`

Returns the **converted position** of the tile in Cartesian/MiniMicro coordinates, where Y increases upward.

```python
pos = tile.position
// output: pos = {"x": 0, "y": 0}
```

> Internally uses `translateCoords()` and the tile’s associated level height to flip the Y-axis appropriately.

---

These methods are useful when drawing or calculating logic for tiles in engines that use bottom-left origins (like MiniMicro), or when transforming LDtk data for grid-based gameplay systems.

---

## 📝 Notes

- `iid` refers to instance ID (unique per level/layer/entity).
- `uid` refers to unique ID used by LDtk internally.
