---@meta
--- Represents a mobile entity within the game, inheriting from LivingEntity and adding movement-related attributes and functions.
---@class MobEntity : LivingEntity
---@field followingPath boolean @Read-Only Indicates whether this entity is currently following a path.
MobEntity = {}

--- Searches for the shortest path to the given position and moves this entity along the path if one is found.
--- The `followingPath` property will be `true` while the entity is moving and will become `false` once it reaches the destination or if the path is blocked for too long.
---
--- ### Example
--- ```lua
--- local pig = spell:summon("pig")
--- local waypoint = pig.pos + Vec3(0, 0, 10)
--- local ok = pig:startFollowPathTo(waypoint, 0, 100, 1)
--- if not ok then
---   error("No path found to waypoint.")
--- end
---
--- while pig.followingPath do
---   sleep(20)
--- end
---
--- if (waypoint - pig.pos):magnitude() > 1 then
---   pig:stopFollowPath()
--- end
--- ```
---@param target Vec3 The position to move toward.
---@param targetRadius number The distance to maintain from the target position.
---@param searchRange number The maximum range to search for a path.
---@param speed number The speed at which the entity moves along the path.
---@return boolean ok `true` if a path is found and movement starts; `false` otherwise.
function MobEntity:startFollowPathTo(target, targetRadius, searchRange, speed)
end

--- Stops this entity's current movement immediately.
function MobEntity:stopFollowPath()
end
