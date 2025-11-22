---@meta
--- Represents a physical item entity in the world, which can be picked up by players or other entities.
--- It includes information about the dropped item, its age, and its original owner.
---@class ItemEntity : Entity
---@field owner Entity @Read-Only A reference to the entity that spawned or owns this item entity.
---@field itemAge number @Read-Only The number of game ticks since this item entity was created in the world.
---@field item Item A reference to the item represented by this item entity.
ItemEntity = {}

--- Creates a new ItemEntity at the spell's current location.
---
--- ### Example
--- ```lua
--- local stick = ItemEntity:new(Item:new("stick"))
--- stick.pos = spell.owner.pos + spell.owner.lookVec * 5
--- ```
---
--- ### Example with Custom NBT
--- ```lua
--- local sword = ItemEntity:new(Item:new("diamond_sword"), {
---     Glowing = 1
--- })
--- ```
---@param item Item The item that this item entity should represent.
---@param nbt table|nil Optional NBT data to merge into the item entity's representation.
---@return ItemEntity itemEntity A new instance representing the dropped item.
function ItemEntity:new(item, nbt)
end
