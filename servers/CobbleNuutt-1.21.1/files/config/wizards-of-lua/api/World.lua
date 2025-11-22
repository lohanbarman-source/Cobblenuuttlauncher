---@meta
--- Represents the in-game world, exposing time, dimension, spawn location, and chunk state information.
---@class World
---@field day boolean @Read-Only Indicates whether it is currently daytime in the world.
---@field night boolean @Read-Only Indicates whether it is currently nighttime in the world.
---@field time number @Read-Only The current in-game time, measured in ticks.
---@field realtime number @Read-Only The real-world time elapsed since the world was created, in milliseconds.
---@field dimension string @Read-Only The identifier of the world’s dimension (e.g., "minecraft:overworld", "minecraft:the_nether").
---@field spawnPos Vec3 The world spawn point where players appear when respawning.
World = {}

--- Checks whether the chunk containing the specified position is currently loaded in memory.
---
--- ### Example
--- ```lua
--- local position = Vec3:new(100, 64, 100)
--- if world:isLoaded(position) then
---     print("The chunk at the specified position is loaded.")
--- else
---     print("The chunk at the specified position is not loaded.")
--- end
--- ```
---@param pos Vec3 The position to check.
---@return boolean loaded `true` if the chunk is loaded, `false` otherwise.
function World:isLoaded(pos) end
