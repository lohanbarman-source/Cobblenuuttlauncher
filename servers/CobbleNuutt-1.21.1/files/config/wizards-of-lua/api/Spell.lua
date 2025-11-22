---@meta
--- Represents a spell in the game, providing methods for interacting with the world, entities, and events.
---@class Spell
---@field world World @Read-Only A reference to the world in which the spell exists.
---@field id number @Read-Only The ID of the spell.
---@field name string The name of the spell.
---@field owner Entity @Read-Only A reference to the entity that owns or cast this spell.
---@field age number @Read-Only The age of the spell in game ticks.
---@field pos Vec3 A copy of the position of the spell in the world.
---@field lookVec Vec3 @Read-Only A copy of the direction vector in which the spell is looking.
---@field facing string @Read-Only The compass direction this spell is facing. One of ‘north’, ‘east’, ‘south’, and ‘west’.
---@field pitch number The pitch rotation angle of the spell.
---@field yaw number The yaw rotation angle of the spell.
---@field velocity Vec3 A copy of the velocity of the spell.
---@field block Block A copy of the block at the spell's position.
---@field blockEntity BlockEntity @Read-Only A reference to the block entity at the spell's position, if any.
---@field forceChunk boolean Specifies whether the chunk containing this spell should stay loaded in memory. Default is `true`.
---@field visible boolean Specifies whether this spell is visible to players. Default is `false`.
---@field server Server @Read-Only Reference to the Minecraft server.
Spell = {}

--- Executes a Minecraft command on behalf of this spell.
---
--- By default, the command's output is sent to the spell's command source.  
--- To inspect the output programmatically instead, you can pass a `Trace` object to capture it.
---
--- The return value is the **command result value** as defined by the Minecraft command system:
--- usually the number of entities or blocks affected by the command.
---
--- ### Example
--- ```lua
--- spell:execute("say Hello, World!")
--- ```
---
--- ### Example with Trace
--- ```lua
--- local trace = Trace:new()
--- local result = spell:execute("/data get entity @p", trace)
--- print("Command returned: " .. result)
--- print("Command output:\n" .. trace.content)
--- ```
---@param command string The command to execute.
---@param trace Trace|nil Optional. A `Trace` object to collect the command's output.
---@return number result The command result value, usually representing the number of entities or blocks affected.
function Spell:execute(command, trace)
end

--- Executes a Minecraft command silently on behalf of this spell.
---
--- In contrast to `spell:execute`, this version **does not forward** the command's output to the spell’s command source.  
--- You can use a `Trace` object to capture the output programmatically.
---
--- The return value is the **command result value** as defined by the Minecraft command system:
--- usually the number of entities or blocks affected by the command.
---
--- ### Example
--- ```lua
--- spell:executeSilent("say Hello, World!")
--- ```
---
--- ### Example with Trace
--- ```lua
--- local trace = Trace:new()
--- local result = spell:executeSilent("/data get entity @p", trace)
--- print("Command returned: " .. result)
--- print("Command output:\n" .. trace.content)
--- ```
---@param command string The command to execute.
---@param trace Trace|nil Optional. A `Trace` object to collect the command's output.
---@return number result The command result value, usually representing the number of entities or blocks affected.
function Spell:executeSilent(command, trace)
end

--- Pauses this spell's execution for a specified number of game ticks.
---
--- ### Example
--- ```lua
--- spell:sleep(40)  -- Pauses for 2 seconds (assuming 20 ticks per second)
--- ```
---@param ticks number The number of game ticks to pause for.
function Spell:sleep(ticks)
end

--- Summons an entity with the given entity ID at the spell's position.
--- Optionally, merges a subset of NBT data into the newly created entity.
---
--- ### Example
--- ```lua
--- local pig = spell:summon("pig", { CustomName = "Piggy" })
--- print("Summoned entity:", pig.name)
--- ```
---@param id string The ID of the entity to summon.
---@param nbt table|nil Optional NBT data to merge into the entity.
---@return Entity entity A reference to the summoned entity. The returned entity may be a subclass of Entity.
function Spell:summon(id, nbt)
end

--- Finds and returns a list of entities matching the specified selector.
---
--- ### Example
--- ```lua
--- local nearbyZombies = spell:findEntities("@e[type=zombie,distance=..10]")
--- for _, entity in ipairs(nearbyZombies) do
---     print("Found entity:", entity.name)
--- end
--- ```
---@param selector string The selector used to find entities (e.g., "@e[type=zombie,distance=..10]").
---@return Entity[] list @A table of references to entities that match the selector criteria.
function Spell:findEntities(selector)
end

--- Finds and returns a list of spells that match the given search criteria.
---
--- ### Example: Search by name:
--- ```lua
--- local spellsByName = spell:findSpells({ name = "My Spell" })
--- for _, s in ipairs(spellsByName) do
---     print("Found spell:", s.name)
--- end
--- ```
---
--- ### Example: Search within a radius by owner:
--- ```lua
--- local nearbySpells = spell:findSpells({ owner = "MickKay", maxradius = 50, excludeSelf = true })
--- for _, s in ipairs(nearbySpells) do
---     print("Nearby spell owned by MickKay:", s.name)
--- end
--- ```
---
--- ### Example: Search by spell ID:
--- ```lua
--- local specificSpell = spell:findSpells({ sid = 1029 })
--- if specificSpell[1] then
---     print("Found spell with ID 1029:", specificSpell[1].name)
--- else
---     print("No spell found with ID 1029.")
--- end
--- ```
---@param criteria table The search criteria. Can include:
---   - `name` (string): The spell's name.
---   - `owner` (string): The owner's name.
---   - `tag` (string): A tag associated with the spell.
---   - `sid` (number): The spell ID.
---   - `maxradius` (number): Maximum radius for the search.
---   - `minradius` (number): Minimum radius for the search.
---   - `excludeSelf` (boolean): Whether to exclude this spell.
---@return Spell[] list @A table of references to spells that match the criteria.
function Spell:findSpells(criteria)
end

--- Collects events matching the specified names into an event queue.
---
--- ### Example
--- ```lua
--- local queue = spell:collect("ChatMessageEvent", "PlayerJoinedEvent")
--- while true do
---     local event = queue:next()
---     if event then
---         print("Collected event:", event.name)
---     end
---     sleep(20)
--- end
--- ```
---@param ... string The names of events to collect.
---@return EventQueue queue The event queue collecting matching events.
function Spell:collect(...)
end

--- Intercepts events matching the specified names and handles them using a callback.
--- To cancel an event, return `false` from within the callback.
--- 
--- The interceptor stays active only while the spell is running.
--- If the spell ends, the interceptor stops automatically.
---
--- ### Example
--- ```lua
--- local interceptor = spell:intercept({"BeforePlayerBlockBreakEvent"}, function(evt)
---   local blockName = evt.block.type.id
---   if blockName == "short_grass" then
---       spell.pos = evt.pos:floor() + Vec3(0.5, 0, 0.5)
---       spell:summon("pig", { Pos = evt.pos, Saddle = true })
---       return false
---   end
---   return true
--- end)
---
--- -- Keep the spell running so the interceptor remains active
--- while true do
---   sleep(20)
--- end
--- ```
---@param names table A table of event names to intercept.
---@param callback function A function that handles events. Return `true` to allow, `false` to cancel.
---@return EventInterceptor interceptor An interceptor that manages the event interception.
function Spell:intercept(names, callback)
end

--- Issues a raycast from this spell’s position and returns the first block hit.
--- See also Entity:raycastBlock.
---@param maxDistance number The maximum distance to cast the ray.
---@return BlockHitResult|nil hit The result of the raycast, indicating the block hit.
function Spell:raycastBlock(maxDistance)
end

--- Issues a raycast from this spell’s position and returns the first entity hit.
--- See also Entity:raycastEntity.
---@param maxDistance number The maximum distance to cast the ray.
---@return EntityHitResult|nil hit The result of the raycast, indicating the entity hit.
function Spell:raycastEntity(maxDistance)
end

--- Issues a raycast from this spell’s position and returns the first block or entity hit.
--- See also Entity:raycast.
---@param maxDistance number The maximum distance to cast the ray.
---@return HitResult|nil hit The result of the raycast, indicating the first block or entity hit.
function Spell:raycast(maxDistance)
end

--- Fires a custom event with the specified name and optional data.
---
--- This method triggers a `CustomEvent` that can be intercepted or collected by other spells.
--- If any interceptor returns `false`, the event is considered canceled, and this method returns `false`.
---
--- If the optional `data` table is provided, it is passed **by reference** to all receivers. That means
--- interceptors and collectors can directly mutate its contents, and the changes will be reflected
--- in the original table after the event is fired.
---
--- ### Example: Event without data
--- ```lua
--- local proceed = spell:fire("CustomSpellEvent")
--- if proceed then
---     print("Event handled without cancellation.")
--- else
---     print("Event was canceled.")
--- end
--- ```
---
--- ### Example: Event with shared data
--- ```lua
--- local payload = { message = "Hello World!", count = 1 }
--- local proceed = spell:fire("CustomSpellEvent", payload)
--- if not proceed then
---     print("Event was canceled.")
--- end
--- print("Modified count:", payload.count)
--- ```
---
--- ### Receiver example
--- ```lua
--- spell:intercept({ "CustomSpellEvent" }, function(event)
---   event.data.count = event.data.count + 1
--- end)
--- ```
---
--- In this example, after `spell:fire(...)`, the `payload.count` will be incremented by the receiver.
---
---@param name string The name of the custom event.
---@param data table|nil Optional table passed to event handlers; can be modified by them.
---@return boolean proceed `true` if the event was not canceled; `false` otherwise.
function Spell:fire(name, data)
end

--- Terminates this spell immediately.
function Spell:kill()
end

--- Moves this spell's position in the specified direction by a given distance.
---
--- Accepts absolute directions ("north", "south", "east", "west", "up", "down") and relative directions ("forward", "back", "left", "right").
--- Relative directions use the spell's current yaw rotation.
---
--- The distance is measured in blocks. If omitted, the spell moves by 1 block.
---
--- ### Example: Move 5 blocks north
--- ```lua
--- spell:move("north", 5)
--- ```
---
--- ### Example: Move up by 2 blocks
--- ```lua
--- spell:move("up", 2)
--- ```
---
--- ### Example: Move forward in the direction the spell is facing
--- ```lua
--- spell:move("forward", 3)
--- ```
---
---@param direction string The direction to move: "north", "south", "west", "east", "up", "down", "forward", "back", "left", or "right".
---@param distance number|nil Optional. The distance to move. Defaults to 1 block.
function Spell:move(direction, distance)
end

--- Evaluates the given text using the Placeholder API.
--- This function requires the Placeholder API jar to be present in the `mods` folder.
---
--- ### Example
--- ```lua
--- local text = "Number of players online: %world:player_count%"
--- local value = spell:evaluate(text)
--- print(value)
--- ```
---@param text string The text to evaluate using the Placeholder API.
---@return string result The evaluated text with placeholders replaced.
function Spell:evaluate(text)
end

--- Copies a box-shaped region of the world as a Structure.
---
--- The region is defined by the spell's position and the opposite corner.
--- The copied Structure can be pasted into the world or saved to the server's filesystem.
---
--- ### Example: Copy and paste a structure
--- ```lua
--- local oppositeCorner = spell.pos + Vec3(10, 5, 10)
--- local struct = spell:copyStructure(oppositeCorner)
--- spell.pos = spell.pos + Vec3(0, 0, 15)
--- spell:pasteStructure(struct)
--- ```
---
--- ### Example: Copy and save a structure
--- ```lua
--- local oppositeCorner = spell.pos + Vec3(10, 10, 10)
--- local struct = spell:copyStructure(oppositeCorner)
--- local filepath = spell.server:saveStructure("arena", struct)
--- print("Structure saved at " .. filepath)
--- ```
---@param oppositeCorner Vec3 The corner position opposite to the spell's current position. Defines the region to copy.
---@param includeEntities boolean|nil Optional. Copy entities within the region. Default is false.
---@param ignoreBlockId string|nil Optional. Block ID to ignore when copying. Default is none.
---@return Structure structure The copied structure object.
function Spell:copyStructure(oppositeCorner, includeEntities, ignoreBlockId) end

--- Pastes a Structure into the world at the spell's position.
---
--- By setting `originPos`, you choose which block in the structure’s internal coordinate system will be placed at the spell’s position.
--- If not provided, (0, 0, 0) is used.
--- Before placement, the structure is rotated clockwise around `originPos` to match the spell’s `facing` property:
---   "south" = 0°, "east" = 90°, "west" = -90°, "north" = 180°.
---
--- ### Example: Paste a loaded structure (default origin)
--- ```lua
--- local struct = spell.server:loadStructure("arena")
--- spell:pasteStructure(struct)
--- ```
---
--- ### Example: Paste using a different origin block
--- ```lua
--- -- Use the block at (5, 0, 0) in the structure as origin and pivot, placing it at spell.pos
--- spell:pasteStructure(struct, Vec3(5, 0, 0))
--- ```
---
--- ### Example: Ignore certain blocks when pasting
--- ```lua
--- spell:pasteStructure(struct, nil, { "minecraft:air" })
--- ```
---@param structure Structure The structure to paste.
---@param originPos Vec3|nil Optional. Block in the structure to use as the origin and rotation pivot. Default is Vec3(0,0,0).
---@param ignoreBlockIds table|nil Optional. Table of block IDs to ignore when pasting.
function Spell:pasteStructure(structure, originPos, ignoreBlockIds) end

--- Sets the spell's yaw so that it faces the given compass direction.
---
--- Valid directions: "north", "south", "west", "east".
---
--- The spell’s yaw property will be updated to the angle corresponding to the direction.
---
--- ### Example
--- ```lua
--- spell:setYaw("north")
--- print(spell.yaw) -- prints 180
--- ```
---@param direction string The compass direction: "north", "south", "west", or "east".
function Spell:setYaw(direction) end
