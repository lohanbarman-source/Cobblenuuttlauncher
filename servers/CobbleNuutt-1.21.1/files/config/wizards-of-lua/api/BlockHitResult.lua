---@meta
--- Represents the result of a raycast that hits a block, providing details about the block's position, the side that was hit, and whether the hit was inside the block's boundaries.
---@class BlockHitResult : HitResult
---@field blockPos Vec3 @Read-Only A copy of the exact position of the block that was hit.
---@field side string @Read-Only The side of the block that was hit (e.g., "north", "south", "east", "west", "up", "down").
---@field inside boolean @Read-Only Indicates whether the raycast hit was inside the block's boundaries.
BlockHitResult = {}
