---@meta
--- Represents an in-game entity, providing properties and methods for interacting with it.
---@class Entity
---@field world World @Read-Only A reference to the world in which the entity exists.
---@field name string The name of the entity.
---@field uuid string @Read-Only The UUID of the entity.
---@field type EntityType @Read-Only The specific type of the entity.
---@field age number @Read-Only The age of the entity in game ticks.
---@field nbt table A copy of the NBT (Named Binary Tag) data attached to the entity.  
--- Changes to this table are **not** automatically applied to the entity.  
---
--- To persist changes, either:
--- 1. Modify the copy and reassign:
--- ```lua
--- local copy = entity.nbt
--- copy.CustomName = '{"text":"Grumpy Pig"}'
--- entity.nbt = copy
--- ```
--- 2. Use `putNbt(...)` to merge changes directly:
--- ```lua
--- entity:putNbt({ CustomName = '{"text":"Grumpy Pig"}' })
--- ```
---@field pos Vec3 The position of the entity in the world.
---@field eyePos Vec3 @Read-Only The position of the entity’s eyes, often used for vision or raycasting.
---@field lookVec Vec3 @Read-Only The direction vector in which the entity is looking.
---@field facing string @Read-Only The compass direction this entity is facing. This is one of ‘north’, ‘east’, ‘south’, and ‘west’.
---@field pitch number The pitch rotation angle of the entity.
---@field yaw number The yaw rotation angle of the entity.
---@field velocity Vec3 The movement velocity of the entity.
---@field invisible boolean Indicates whether the entity is currently invisible.
---@field alive boolean @Read-Only Specifies if the entity is alive.
---@field sprinting boolean Indicates whether the entity is currently sprinting.
---@field crawling boolean @Read-Only Specifies if the entity is crawling.
---@field sneaking boolean Indicates whether the entity is currently sneaking.
---@field extra table A copy of custom dynamic data associated with the entity. This data is persisted alongside the regular NBT and can be used to store arbitrary script-defined state.  
--- Like `nbt`, this field returns a copy. Changes must be reassigned or applied via `putExtra(...)`.  
---
--- Example:
--- ```lua
--- local copy = entity.extra
--- copy.tagged = true
--- entity.extra = copy
--- -- or directly
--- entity:putExtra({ tagged = true })
--- ```
Entity = {}

--- Merges the specified NBT data into this entity's existing data.
--- ### Example
--- ```lua
--- local pig = spell:summon("pig")
--- pig:putNbt({Saddle = 1})
--- ```
---@param nbt table The NBT data to merge, which can include custom properties and attributes.
function Entity:putNbt(nbt)
end

--- Merges the given data into the entity's `extra` field.
--- Use this to store custom script-defined values that persist with the entity.
---
--- ### Example
--- ```lua
--- spell.owner:putExtra({notes = "temporary invincibility", expires = 600})
--- print(spell.owner.extra.notes)
--- ```
---@param nbt table The extra data to merge into the `extra` field.
function Entity:putExtra(nbt)
end

--- Kills this entity, marking it as no longer alive and removing it from the game.
--- ### Example
--- ```lua
--- local entities = spell:findEntities("@e[type=pig]")
--- for i, v in ipairs(entities) do
---     if v.nbt.Saddle == 1 then
---         v:kill()
---     end
--- end
--- ```
function Entity:kill()
end

--- Issues a raycast from this entity's eye position in the direction of its look vector,
--- and returns a BlockHitResult indicating the first block encountered within the specified distance.
---
--- ### Example
--- ```lua
--- local function scan()
---     local o = spell.owner
---     local h = o:raycastBlock(5)
---     spell.pos = h.blockPos
---     if spell.block.type.id == "air" then
---         return
---     end
---     print("\"" .. spell.block.type.name .. "\"", spell.block.type.id)
--- end
--- while true do
---     scan()
---     sleep(20)
--- end
--- ```
---@param maxDistance number The maximum distance to cast the ray.
---@return BlockHitResult|nil hit The result of the raycast, indicating the block hit.
function Entity:raycastBlock(maxDistance)
end

--- Issues a raycast from this entity's eye position in the direction of its look vector,
--- and returns an EntityHitResult indicating the first entity encountered within the specified distance.
---
--- ### Example
--- ```lua
--- local function scan()
---     local o = spell.owner
---     local h = o:raycastEntity(8)
---     if h then
---         print("\"" .. h.entity.name .. "\"", h.entity.type.id)
---     end
--- end
--- while true do
---     scan()
---     sleep(20)
--- end
--- ```
---@param maxDistance number The maximum distance to cast the ray.
---@return EntityHitResult|nil hit The result of the raycast, indicating the entity hit.
function Entity:raycastEntity(maxDistance)
end

--- Issues a raycast from this entity's eye position in the direction of its look vector,
--- and returns a HitResult indicating the first block or entity encountered within the specified distance.
---
--- ### Example
--- ```lua
--- local function scan()
---     local o = spell.owner
---     local h = o:raycast(8)
---     if h then
---         if h.type == "ENTITY" then
---             ---@cast h EntityHitResult
---             print("\"" .. h.entity.name .. "\"", h.entity.type.id)
---         elseif h.type == "BLOCK" then
---             ---@cast h BlockHitResult
---             if spell.block.type.id ~= "air" then
---                 print("\"" .. spell.block.type.name .. "\"", spell.block.type.id)
---             end
---         end
---     end
--- end
--- while true do
---     scan()
---     sleep(20)
--- end
--- ```
---@param maxDistance number The maximum distance to cast the ray.
---@return HitResult|nil hit The result of the raycast, indicating the first block or entity hit.
function Entity:raycast(maxDistance)
end

--- Drops an item entity from this entity's position with an optional vertical offset.
---
--- ### Example
--- ```lua
--- local item = spell.owner:getItemInHand("MAIN_HAND")
--- spell.owner:dropItem(item, -2)
--- spell.owner:setItemInHand("MAIN_HAND", nil)  -- Clears the item from the player's main hand
--- ```
---@param object any The item to drop; can be of type Item, BlockType, or ItemType.
---@param yOffset number|nil Optional. The vertical offset relative to this entity's position. Defaults to 0.
---@return ItemEntity item A reference to the dropped item entity.
function Entity:dropItem(object, yOffset)
end

--- Evaluates the given text using the Placeholder API.
--- This function requires the Placeholder API jar to be present in the `mods` folder.
---
--- ### Example
--- ```lua
--- local player = spell.owner
--- local text = "%player:name%'s ping: %player:ping%"
--- local value = player:evaluate(text)
--- print(value)
--- ```
---@param text string The text to evaluate using the Placeholder API.
---@return string result The evaluated text with placeholders replaced.
function Entity:evaluate(text)
end
