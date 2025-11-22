---@meta
--- Represents the Minecraft server that is running the game.
--- Provides access to server-wide operations such as loading and saving structures.
---@class Server
---@field version string @Read-Only The Minecraft version of this server.
---@field filesystem Filesystem @Read-Only A reference to the server's filesystem.
---@field players Player[] @Read-Only A list of references to all currently online players.
Server = {}

--- Loads a Structure from the server's filesystem or internal repository by its name.
---
--- Returns a Structure object that can be pasted into the world or inspected.
---
--- ### Example: Load and paste a structure
--- ```lua
--- local struct = spell.server:loadStructure("arena")
--- spell:pasteStructure(struct)
--- ```
---@param name string The name of the structure to load.
---@return Structure structure The loaded structure object.
function Server:loadStructure(name) end

--- Saves a Structure to the server's filesystem with the given name.
---
--- Returns the file path where the structure was saved.
---
--- ### Example: Copy and save a structure
--- ```lua
--- local struct = spell:copyStructure(spell.pos + Vec3(10, 10, 10))
--- local path = spell.server:saveStructure("arena", struct)
--- print("Saved at " .. path)
--- ```
---@param name string The name to use for saving the structure.
---@param structure Structure The structure to save.
---@return string path The file path where the structure is saved.
function Server:saveStructure(name, structure) end

--- Returns a reference to the world for the given dimension name.
---
--- ### Example
--- ```lua
--- local nether = spell.server:getWorld("the_nether")
--- player:teleport(nether, Vec3(0,64,0))
--- ```
---@param dimension string The name of the dimension, e.g. "the_nether" or "overworld"
---@return World world A reference to the world that represents the given dimension.
function Server:getWorld(dimension) end
