---@meta
--- Represents the result of a raycast or similar action, containing details about the position and the type of object hit.
---@class HitResult
---@field pos Vec3 @Read-Only A copy of the position where the hit occurred.
---@field type string @Read-Only The type of hit, indicating what was hit (e.g., "BLOCK" or "ENTITY").
HitResult = {}
