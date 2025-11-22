---@meta
--- Represents a living entity in the game, inheriting from Entity and including attributes specific to living creatures, such as health, age state, and hostility.
---@class LivingEntity : Entity
---@field health number The current health of the entity.
---@field baby boolean @Read-Only Indicates whether the entity is a baby.
---@field hostile boolean @Read-Only Indicates whether the entity behaves in a hostile manner toward players or other entities.
LivingEntity = {}

--- Returns the item currently held in the specified hand.
---
--- ### Example
--- ```lua
--- local item = spell.owner:getItemInHand("MAIN_HAND")
--- if item then
---   print("Item in hand:", item.name)
--- end
--- ```
---@param hand string The hand to check; should be either `"MAIN_HAND"` or `"OFF_HAND"`.
---@return Item|nil item The item held in the specified hand, or `nil` if the hand is empty.
function LivingEntity:getItemInHand(hand)
end

--- Places the given item into the specified hand.
---
--- ### Example
--- ```lua
--- local sword = Item:new("diamond_sword")
--- spell.owner:setItemInHand("MAIN_HAND", sword)
--- ```
---@param hand string The hand to equip; should be either `"MAIN_HAND"` or `"OFF_HAND"`.
---@return Item|nil The item held in the specified hand, or `nil` if empty.
function LivingEntity:setItemInHand(hand, item)
end

--- Returns the item currently held in the specified equipment slot.
---
--- ### Example
--- ```lua
--- local piglin = spell:summon("piglin_brute")
--- ---@cast piglin LivingEntity
--- print(str(piglin:getEquipment("mainhand")))
--- ```
---@param equipmentSlot string The equipment slot; should be either "mainhand", "offhand", "feet", "legs", "chest", "head", "body".
---@return Item|nil item The item held in the specified equipment slot, or `nil` if the slot is empty.
function LivingEntity:getEquipment(equipmentSlot)
end

--- Places the given item into the specified equipment slot.
---
--- ### Example
--- ```lua
--- local zombie = spell:summon("zombie")
--- ---@cast zombie LivingEntity
--- zombie:setEquipment("mainhand", Item:new("diamond_sword"))
--- zombie:setEquipment("head", Item:new("diamond_helmet"))
--- ```
---@param equipmentSlot string The equipment slot to equip; should be either "mainhand", "offhand", "feet", "legs", "chest", "head", "body".
---@param item Item The item to place in the specified slot.
function LivingEntity:setEquipment(equipmentSlot, item)
end
