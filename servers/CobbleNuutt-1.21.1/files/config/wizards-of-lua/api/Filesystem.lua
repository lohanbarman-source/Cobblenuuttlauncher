---@meta
--- Provides access to the server’s `world` folder for managing files and directories.
--- 
--- To create, write, and read files use Lua's standard io module:
---
--- ```lua
--- local advancements = spell.server.filesystem:list("advancements")
--- for i,filename in ipairs(advancements) do
---     local filepath = "advancements/"..filename
---     local f = io.open(filepath, "r")
---     if f then
---         local text = f:read("*a")
---         print(filename, text)
---         f:close()
---     end
--- end
--- ```
---@class Filesystem
Filesystem = {}

--- Returns a list of file and directory names in the specified directory.
---
--- If `path` is omitted or `nil`, lists the root directory.
---
--- ### Example: List contents of a directory
--- ```lua
--- local files = spell.server.filesystem:list("region")
--- for _, name in ipairs(files) do
---     print(name)
--- end
--- ```
---
--- ### Example: List root directory
--- ```lua
--- local files = spell.server.filesystem:list()
--- for _, name in ipairs(files) do
---     print(name)
--- end
--- ```
---@param path string|nil Optional. Directory path to list. Lists root if omitted.
---@return string[] files List of file and directory names.
function Filesystem:list(path) end

--- Checks if the given path is a directory.
---
--- ### Example
--- ```lua
--- if spell.server.filesystem:isDir("advancements") then
---     print("structures is a directory.")
--- end
--- ```
---@param path string Path to check.
---@return boolean result True if path is a directory, false otherwise.
function Filesystem:isDir(path) end

--- Checks if the given path is a regular file.
---
--- ### Example
--- ```lua
--- if spell.server.filesystem:isFile("generated/minecraft/structures/arena.nbt") then
---     print("Arena structure exists.")
--- end
--- ```
---@param path string Path to check.
---@return boolean result True if path is a file, false otherwise.
function Filesystem:isFile(path) end

--- Creates a directory at the given path.
---
--- ### Example
--- ```lua
--- if spell.server.filesystem:makeDir("backups") then
---     print("Directory created.")
--- else
---     print("Failed to create directory.")
--- end
--- ```
---@param path string Directory path to create.
---@return boolean result True if successful, false otherwise.
function Filesystem:makeDir(path) end

--- Deletes a file or an empty directory.
--- The directory must be empty to be deleted.
---
--- ### Example
--- ```lua
--- if spell.server.filesystem:delete("backups/old") then
---     print("Deleted successfully.")
--- else
---     print("Delete failed.")
--- end
--- ```
---@param path string Path to the file or directory.
---@return boolean result True if successful, false otherwise.
function Filesystem:delete(path) end

--- Moves or renames a file or directory.
---
--- ### Example
--- ```lua
--- if spell.server.filesystem:move(
---      "generated/minecraft/structures/arena.nbt", 
---      "archive/arena.nbt")
--- then
---     print("File moved to archive.")
--- else
---     print("Move failed.")
--- end
--- ```
---@param fromPath string Current path.
---@param toPath string New path.
---@return boolean result True if successful, false otherwise.
function Filesystem:move(fromPath, toPath) end
