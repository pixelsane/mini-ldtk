# Basic Usage
## Setup
```lua
// Everything is under LDtkProject class
project = LDtkProject.loadFile("res/world.ldtk")

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
project = LDtkProject.loadFile("game/levels.ldtk", true)
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
Returns the world position of the level as `{x, y}`.

```lua
pos = level.position
// output: {pos.x, pos.y}
```

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

---


## 📝 Notes

- `iid` refers to instance ID (unique per level/layer/entity).
- `uid` refers to unique ID used by LDtk internally.
- All `Unsafe` methods return `null` instead of crashing when the target is not found.
