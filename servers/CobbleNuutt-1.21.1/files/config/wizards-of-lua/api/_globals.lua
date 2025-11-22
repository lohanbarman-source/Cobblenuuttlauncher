---@meta

--- The spell instance assigned to the currently running Lua program.
---@type Spell
---@diagnostic disable-next-line: missing-fields
spell = {}

-- Sends a message to the configured logging target, independently of the `sendCommandFeedback` gamerule.
---
--- The `log(...)` function behaves like Lua's built-in `print(...)`, but its output is controlled by the `WizardsOfLua.log` setting.
--- This allows consistent debugging output even when command feedback is globally suppressed.
---
--- See `WizardsOfLua.log` for details on how to configure the output target.
---
--- ### Example
--- ```lua
--- log("Spell is active at", spell.pos)
--- log("Block type:", spell.block.type.id)
--- ```
---
--- @param value any The first value to log.
--- @vararg any Additional values to log, all will be converted to strings and space-separated.
function log(value, ...) end

--- Converts the given object into a string representation.
---
--- This is a simplified alias for `inspect(obj, { metatables = false })`, omitting metatables for cleaner output.
---
--- ### Example
--- ```lua
--- print(str({foo = "bar"}))  -- => { foo = "bar" }
--- ```
---@param obj any The object to convert.
---@return string A string representation of the object.
function str(obj) end

--- Converts the given Lua value into a human-readable string representation.
---
--- This function is especially useful for printing or logging deeply nested tables, such as configurations, game state, or debug info.
--- It safely handles cyclic references, shared references, metatables, and offers advanced formatting via the `process` callback.
---
--- ### Example
--- ```lua
--- local t = { foo = "bar", list = {1, 2, 3} }
--- print(inspect(t))  -- => { foo = "bar", list = { 1, 2, 3 } }
--- ```
---
--- ### Options
--- - `depth` (number): Maximum depth to recurse into nested tables. Default: `math.huge`.
--- - `newline` (string): Line separator used in output. Default: `"\n"`.
--- - `indent` (string): Indentation string per level. Default: `"  "` (two spaces).
--- - `metatables` (boolean): Whether to include metatables. Default: `true`.
--- - `process` (fun(value: any, path: table): any): Callback to transform values before they’re printed. Receives the value and its path in the table.
---
--- ### Example with Options
--- ```lua
--- local t = { player = { name = "Steve", score = 42 } }
--- print(inspect(t, {
---   depth = 1,
---   indent = "\t",
---   metatables = false
--- }))
--- ```
---
--- ### Example with `process` Option
--- ```lua
--- print(inspect(gameData, {
---   process = function(value, path)
---     if type(value) == "string" and #value > 50 then
---       return "<string truncated>"
---     end
---     return value
---   end
--- }))
--- ```
---@param value any The Lua value to inspect (usually a table, but can be any type).
---@param options table|nil Optional formatting options (see above).
---@return string A formatted string representing the structure and content of the value.
function inspect(value, options) end

--- Pauses this program's execution for a specified number of game ticks.
---
--- ### Example
--- ```lua
--- sleep(20) -- pauses for 1 second (assuming 20 ticks per second)
--- ```
---@param ticks number The number of game ticks to pause for.
function sleep(ticks) end

--- Declares a new class type with the given name.
---
--- This function creates a new class metatable, optionally inheriting from a superclass metatable.
---
--- ### Example
--- ```lua
--- MyClass = declare("MyClass")
--- SubClass = declare("SubClass", MyClass)
--- ```
---@param name string The name of the class to declare.
---@param superclass_metatable table|nil The metatable of the superclass, or `nil` for a base class.
---@return table The metatable for the newly declared class.
function declare(name, superclass_metatable) end

--- Checks whether the given object is an instance of the specified class.
---
--- This performs a recursive check using metatable inheritance.
---
--- ### Example
--- ```lua
--- if instanceOf(MyClass, obj) then
---   print("This is an instance of MyClass!")
--- end
--- ```
---@param class_metatable table The metatable of the class to check against.
---@param object table The object to check.
---@return boolean `true` if the object is an instance of the class, `false` otherwise.
function instanceOf(class_metatable, object) end
