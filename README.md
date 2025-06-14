
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

[Here](https://github.com/pixelsane/mini-ldtk/blob/main/docs.md)'s a very short documentation.

```lua
project = new LDtkProject
project.loadFile("res/world.ldtk")

level = project.getLevel("Level_1")
layer = level.getLayer("Collision")

isWall = layer.getIntGridAt(10, 5) == 1
player = level.getEntity("Player")

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

- Add a non-minimicro dependent version. Replacing qa and json.
- Full support for entity fields and complex types
- Helper functions for common queries
- Layer type introspection
- Better error handling and validation
- Integrated MiniMicro sprite display support

## Contributing

Contributions, bug reports, and suggestions are welcome! This project is meant to stay lightweight and MiniScript idiomatic, so keep it simple.

## License

This project is open source and licensed under the MIT License.
