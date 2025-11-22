---@meta
--- Represents an in-game item, including information about its type, name, quantity, durability, and metadata.
---@class Item
---@field type ItemType @Read-Only A reference to the specific type of the item (e.g., "sword", "pickaxe").
---@field name string The name of the item, typically a human-readable label.
---@field count number The quantity of the item in a stack.
---@field maxCount number @Read-Only The maximum quantity of the item in a stack.
---@field stackable boolean @Read-Only Indicates whether the item can be stacked.
---@field maxDamage number @Read-Only The maximum durability value this item can have before breaking.
---@field damage number The current damage value, representing how worn or used the item is.
---@field nbt table A copy of the NBT (Named Binary Tag) data attached to the item, including custom components and metadata.  
--- Changes made to this table do **not** affect the actual item until reassigned.  
---  
--- To modify the NBT effectively, use one of the following methods:  
--- 1. Retrieve a copy, modify it, then reassign:  
--- ```lua
--- local copy = item.nbt
--- copy.count = copy.count + 1
--- item.nbt = copy
--- ```  
--- 2. Use `putNbt(...)` to merge changes:  
--- ```lua
--- item:putNbt({ count = 20 })
--- ```
Item = {}

--- Creates a new item with the specified ID and optional NBT data.
---
--- ### Example
--- ```lua
--- local item = Item:new("diamond_sword", {
---   components = {
---     custom_name = '{"text":"Radiant Diamond Sword","color":"aqua","bold":true,"italic":false}',
---     lore = {'{"text":"A diamond sword shimmering with energy","color":"gold","bold":true}'}
---   }
--- })
--- ```
---@param id string The item type identifier (e.g., "diamond_sword", "torch").
---@param nbt table|nil Optional NBT data for customizing the item’s appearance or behavior.
---@return Item item A new item instance with the specified type and optional NBT data.
function Item:new(id, nbt)
end

--- Merges the given NBT data into this item's existing NBT.
---
--- This updates properties like the custom name, enchantments, or other item components.
---
--- ### Example
--- ```lua
--- item:putNbt({
---   components = {
---     enchantments = { 
---       levels = { 
---         sharpness = 5 
---       } 
---     }
---   }
--- })
--- ```
---@param nbt table The NBT data to merge into this item.
function Item:putNbt(nbt)
end

--- Creates a copy of this item.
---
--- ### Example
--- ```lua
--- local item = spell.owner.mainHandItem:copy()
--- spell.owner.inventory[40] = item
--- ```
---@return Item item A new copy of this item.
function Item:copy()
end
