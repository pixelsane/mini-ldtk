
# MiniScript LDtk Parser

This is a **MiniScript LDtk parser** — a library for working with [LDtk](https://ldtk.io) level files inside MiniScript projects.

## Why?

This parser was created for use in my upcoming microjam 041, but I decided to share it publicly so others using MiniScript can take advantage of LDtk in their own projects.

I like MiniScript and plan on using it for many future projects, so this parser will be **actively maintained**. It’s currently **barebones**, but the **core functionality is sufficient** to build most types of games.

## Features

- Load LDtk `.ldtk` project files
- Access levels by name, IID, or UID
- Query layers, int grid data, and tile data
- Retrieve placed entities and their fields
- Access enum definitions and values
- Supports tiled and grid-based logic

## Current Status

The parser is minimal, but it includes everything needed for most practical use cases:

- No dependencies
- No loops required to use it

## Usage Example

[DOCUMENTATION](https://github.com/pixelsane/mini-ldtk/blob/main/docs.md)

Example and Setup

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

display(5).mode = displayMode.tile
display(5).tileSet = file.loadImage("/usr/tilesets/environment.png")

// Convenient single function to configure TileDisplay but it is optional
environmentLayer.initTileDisplay display(5)
furnitureLayer.initTileDisplay display(5)

// Convenient single function to directly send tiles to to display
environmentLayer.pushTilesToDisplay display(5)
furnitureLayer.pushTilesToDisplay display(5)

// Ex: Bounds checking using IntGrid
isWall = collisionLayer.getIntGridAt(10, 5) == 1

pprint "Player at: " + player.x + ", " + player.y
```

## API Overview

A complete breakdown of available methods and how to use them is available in the `docs.md` file. The parser includes accessors for:

- Project, contains all subsequent classes (`LDtkProject`)
- Level metadata and contents
- Layer data (tiles, int grids, etc.)
- Entities and their fields
- Enums and enum values

## Planned Improvements

- Full support for entity fields and complex types
- Helper functions for common queries
- Layer type introspection
- Better error handling and validation

## Contributing

Contributions, bug reports, and suggestions are welcome! This project is meant to stay lightweight and MiniScript idiomatic, so keep it simple.

## License

This project is open source and licensed under the MIT License.
