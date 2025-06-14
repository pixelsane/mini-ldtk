# Basic Usage
## Setup
```lua
// Everything is under LDtkProject class
// Remember to instantiate a new LDtkProject object
project = new LDtkProject
project.loadFile("res/world.ldtk")

level = project.getLevel("Level_1")
layer = level.getLayer("Collision")
gridToCheck = layer.getIntGridAt(10, 5)

player = level.getEntity("Player")
```

## Access Raw LDtk Data
```lua
  // Raw LDtk/JSON data can be found in
  raw = LDtkProject.data

  // Access
  raw.levels[0]
  raw.defs.layers
  raw.defs.entities

    
```

# LDtk Parser Cheatsheet

## LDtkProject Methods

### `LDtkProject.loadFile(dir, supersimple = false)`
Loads an LDtk file from the given directory. supersimple not yet implemented.

```lua
project = new LDtkProject
project.loadFile("game/levels.ldtk", true)
```

---

### `LDtkProject.getAllLevels`
Returns a list of all levels.

```lua
for level in project.getAllLevels
  pprint(level.name)
end
```

---

### `LDtkProject.getLevel(identifier, iid = null, uid = null)`
Returns a level by its identifier, `iid`, or `uid`.

```lua
level = project.getLevel("Level_1")
```

---

### `LDtkProject.getLevelSafe(...)`
Same as `getLevel`, but **throws an error** if no match is found.  
Use this when you want to catch issues early and avoid silently operating on `null`.

---

### `LDtkProject.getAllTilesets`
Returns all tilesets.

---

### `LDtkProject.getTileset(identifier, uid = null)`
Returns a tileset by identifier or UID.

---

### `LDtkProject.getTilesetSafe(...)`
Same as `getTileset`, but **throws an error** if no match is found.  
Use this when you want to catch issues early and avoid silently operating on `null`.

---

### `LDtkProject.getAllEnums`
Returns all enum definitions.

---

### `LDtkProject.getEnum(identifier, uid = null)`
Returns enum by name or UID.

---

### `LDtkProject.getEnumSafe(...)`
Safe version of `getEnum`.

---

### `LDtkProject.getEnumValue(id, enumIdentifier, enumUid = false)`
Returns a specific enum value by its ID and enum name or UID.

---

### `LDtkProject.getEnumValueSafe(...)`
Safe version of `getEnumValue`.

---

### `LDtkProject.defaultGridSize`
Returns the project's default grid size.

---

### `LDtkProject.levelSize(identifier, id = null, iid = null)`
Returns size of the specified level.

```lua
size = project.levelSize("Level_1")
ppprint [size.width, size.height]
```

---

## Layer Methods (`layerMethods`)

### `layerMethods.name`
Returns the name of the layer.

```lua
pprint layer.name --> "Collision"
```

---

### `layerMethods.gridToIndex(x, y)`
Converts grid coordinates `(x, y)` into a 1D array index.

```lua
index = layer.gridToIndex(3, 5)
```

---

### `layerMethods.getAllTiles`
Returns a list of all tiles in the layer.

```lua
for tile in layer.getAllTiles
  x = tile.x
  y = tile.y
  id = tile.tileId
end
```

---

### `layerMethods.getIntGridAt(x, y)`
Returns the int grid value at the specified `(x, y)` position.

```lua
if layer.getIntGridAt(10, 12) == 1 then
  pprint "Wall here!"
end
```

---

## level Methods (`levelMethods`)

### `levelMethods.getAllEntities`
Returns all entities in the level.

```lua
for ent in level.getAllEntities
  pprint(ent.identifier, ent.x, ent.y)
end
```

---

### `levelMethods.getEntity(identifier, iid = null)`
Returns the first matching entity by identifier or `iid`.

```lua
player = level.getEntity("Player")
```

---

### `levelMethods.name`
Returns the level name.

```lua
pprint level.name --> "Level_1"
```

---

### `levelMethods.position`

Returns the level's **position in Cartesian/MiniMicro coordinates**, where Y increases upward.

This is useful for rendering in environments where the origin is bottom-left, such as MiniMicro.

```lua
pos = level.position
print(pos.x, pos.y)
```

> Internally, this subtracts the LDtk Y-coordinate from the level height.

---

### `level.positionRaw`

Returns the level's **raw LDtk position**, exactly as it appears in the `.ldtk` file. In LDtk, the origin is top-left.

```lua
rawPos = level.positionRaw
print(rawPos.x, rawPos.y)
```

> Use this if you need to work in screen-space or match LDtk’s layout directly.

---

### `levelMethods.size`
Returns the size of the level in pixels.

```lua
sz = level.size
// output: {sz.width, sz.height}
```

---

### `levelMethods.gridSize`
Returns the grid dimensions of the level.

```lua
grid = level.gridSize
pprint(grid.width, grid.height)
```

---

### `levelMethods.getLayer(identifier, iid = null)`
Returns a specific layer by its identifier or `iid`.

```lua
collision = level.getLayer("Collision")
```

---

### `levelMethods.getIntGridAt(layerIdentifier, x, y)`
Returns the int grid value at `(x, y)` for the specified layer.

```lua
if level.getIntGridAt("Collision", 5, 5) > 0 then
  pprint("Blocked!")
end
```

## Global and Helpers
### `translateCoords(coords, levelHeight, to="minimicro")`

Converts a coordinate table between **LDtk (top-down)** and **MiniMicro/Cartesian (bottom-up)** systems.

#### Parameters:
- `coords`: A coordinate map containing `{x, y}`
- `levelHeight`: The height of the level in pixels

#### Returns:
A new `{x, y}` table with Y-axis flipped or adjusted.

#### Example:
```lua
ldtkPos = {"x": 100, "y": 120}
worldPos = translateCoords(ldtkPos, 240)
```

> This is helpful for placing objects correctly when LDtk and your minimicro disagree on coordinate orientation.

---

## entityMethods

### `entity.positionRaw`

Returns the **raw position of the entity**, as stored in LDtk. This reflects the pixel position from the top-left corner (LDtk screen space).

```lua
pos = entity.positionRaw
print(pos.x, pos.y)
```

> Use this when working directly with LDtk's coordinate space or tile-aligned rendering.

---

### `entity.position`

Returns the **converted position** of the entity in Cartesian or MiniMicro coordinates, where the Y-axis increases upwards.

```lua
pos = entity.position
pprint(pos.x, pos.y)
```

> This uses `translateCoords` internally and requires the entity’s `levelHeight` to be defined (automatically set when parsing through levels).

---

## tileMethods

### `tile.positionRaw()`

Returns the **raw position of the tile** in pixels, based on LDtk's coordinate system (top-left origin).

```lua
pos = tile.positionRaw()
print(pos.x, pos.y)
```

> Use this for working with LDtk-native layouts or matching tiles directly to visual assets.

---

### `tile.position()`

Returns the **converted position** of the tile in Cartesian/MiniMicro coordinates, where Y increases upward.

```lua
pos = tile.position()
print(pos.x, pos.y)
```

> Internally uses `translateCoords()` and the tile’s associated level height to flip the Y-axis appropriately.

---

These methods are useful when drawing or calculating logic for tiles in engines that use bottom-left origins (like MiniMicro), or when transforming LDtk data for grid-based gameplay systems.

---

## 📝 Notes

- `iid` refers to instance ID (unique per level/layer/entity).
- `uid` refers to unique ID used by LDtk internally.
- All `Unsafe` methods return `null` instead of crashing when the target is not found.
