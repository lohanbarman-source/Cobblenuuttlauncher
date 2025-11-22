---@meta
--- Represents a block in the game, describing its type, light emission, and other characteristics.
---@class Block
---@field type BlockType @Read-Only A reference to the specific type of the block (e.g., stone, dirt).
---@field luminance number @Read-Only The light level emitted by the block.
---@field burnable boolean @Read-Only Indicates whether the block is flammable.
---@field opaque boolean @Read-Only Indicates whether the block is opaque and blocks light.
---@field toolRequired boolean @Read-Only Indicates whether a specific tool is required to break the block effectively.
---@field data table @Read-Only table A reference to the modifiable collection of additional block-specific attributes. For example, a "ladder" has a "facing" attribute, and "grass" has a "snowy" attribute.
Block = {}

--- Initializes a new block with the specified type.
---
--- ### Example
--- ```lua
--- local b = Block:new("stone")
--- print(b.type)  -- Outputs "stone"
--- ```
---@param id string The identifier for the block type (e.g., "stone", "wood").
---@return Block block A new instance of a Block with the specified type.
function Block:new(id)
end
