# Basic Usage
## Setup
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

// Convenient single function to directly send tiles to to display
display(5).mode = displayMode.tile
environmentLayer.pushTilesToDisplay(display(5))
furnitureLayer.pushTilesToDisplay(display(5))

// Ex: Bounds checking using IntGrid
isWall = layer.getIntGridAt(10, 5) == 1

pprint "Player at: " + player.x + ", " + player.y
```

## Access Raw LDtk Data
```python
  // Raw LDtk/JSON data can be found in
  raw = LDtkProject.data

  // Access
  raw.levels[0]
  raw.defs.layers
  raw.defs.entities

    
```

# LDtk Parser Cheatsheet


## Global and Helpers
### `translateCoords(coords, levelHeight, to="minimicro")`

Converts a coordinate table between **LDtk (top-down)** and **MiniMicro/Cartesian (bottom-up)** systems.

#### Parameters:
- `coords`: A coordinate map containing `{x, y}`
- `levelHeight`: The height of the level in pixels

#### Returns:
A new `{x, y}` table with Y-axis flipped or adjusted.

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
  pprint(level.name)
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

## Layer Methods (`layerMethods`)

### `layerMethods.name`
Returns the name of the layer.

```python
pprint layer.name --> "Collision"
```

---

### `layerMethods.gridToIndex(x, y)`
Converts grid coordinates `(x, y)` into a 1D array index.

```python
index = layer.gridToIndex(3, 5)
```

---

### `layerMethods.getAllTiles`
Returns a list of all tiles in the layer.

```python
for tile in layer.getAllTiles
  x = tile.x
  y = tile.y
  id = tile.tileId
end
```

---

### `layerMethods.pushTilesToDisplay(disp)`

Pushes all the tiles from this layer to a given `TileDisplay`.

```python
layer = level.getLayer("Environment")
layer.pushTilesToDisplay(TILE_DISP)
```

> The target `disp` must be a valid TileDisplay and an image tileset must be loaded.

---


### `layerMethods.getIntGridAt(x, y)`
Returns the int grid value at the specified `(x, y)` position.

```python
if layer.getIntGridAt(10, 12) == 1 then
  pprint "Wall here!"
end
```

---

## level Methods (`levelMethods`)

### `levelMethods.getAllEntities`
Returns all entities in the level.

```python
for ent in level.getAllEntities
  pprint(ent.identifier, ent.x, ent.y)
end
```

---

### `levelMethods.getEntity(identifier, iid = null)`
Returns the first matching entity by identifier or `iid`.

```python
player = level.getEntity("Player")
```

---

### `levelMethods.name`
Returns the level name.

```python
pprint level.name --> "Level_1"
```

---

### `levelMethods.position`

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

### `levelMethods.size`
Returns the size of the level in pixels.

```python
sz = level.size
// output: {sz.width, sz.height}
```

---

### `levelMethods.gridSize`
Returns the grid dimensions of the level.

```python
grid = level.gridSize
pprint(grid.width, grid.height)
```

---

### `levelMethods.getLayer(identifier, iid = null)`
Returns a specific layer by its identifier or `iid`.

```python
collision = level.getLayer("Collision")
```

---

### `levelMethods.getIntGridAt(layerIdentifier, x, y)`
Returns the int grid value at `(x, y)` for the specified layer.

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
pprint(pos)
// output: {x: int, y: int}
```

> Use this when working directly with LDtk's coordinate space or tile-aligned rendering.

---

### `entity.position`

Returns the **converted position** of the entity in Cartesian or MiniMicro coordinates, where the Y-axis increases upwards.

> This uses `translateCoords` internally and requires the entity’s `levelHeight` to be defined (automatically set when parsing through levels).

```python
pos = entity.position
pprint(pos)
// output: {x: int, y: int}
```

### `entity.getAllFields`

Returns a list of **all field instances** on this entity.

```python
fields = entity.getAllFields
for field in fields
    pprint(field.__identifier, field.__value)
end for

> Each field instance is a table with metadata like `__identifier`, `__type`, and `__value`.
```

---


### `entity.getField(identifier, defuid = null)`

Returns the **raw field object** matching the given field name (`identifier`). You can optionally pass the `defuid` if needed to disambiguate multiple field definitions with the same name.

```python
field = entity.getField("Speed")
pprint(field.__type, field.__value)
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
print(pos.x, pos.y)
```

> Use this for working with LDtk-native layouts or matching tiles directly to visual assets.

---

### `tile.position`

Returns the **converted position** of the tile in Cartesian/MiniMicro coordinates, where Y increases upward.

```python
pos = tile.position
print(pos.x, pos.y)
```

> Internally uses `translateCoords()` and the tile’s associated level height to flip the Y-axis appropriately.

---

These methods are useful when drawing or calculating logic for tiles in engines that use bottom-left origins (like MiniMicro), or when transforming LDtk data for grid-based gameplay systems.

---

## 📝 Notes

- `iid` refers to instance ID (unique per level/layer/entity).
- `uid` refers to unique ID used by LDtk internally.
