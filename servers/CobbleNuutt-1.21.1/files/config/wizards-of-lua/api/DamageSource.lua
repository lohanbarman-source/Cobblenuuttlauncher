---@meta
--- Represents the origin and cause of damage in the game, including involved entities and the impact location.
---@class DamageSource
---@field name string @Read-Only The description or message associated with the damage source.
---@field attacker Entity|nil @Read-Only Optional reference to the entity responsible for causing the damage (e.g., a Blaze).
---@field source Entity|nil @Read-Only Optional reference to the entity that delivered the damage (e.g., a Fireball).
---@field pos Vec3|nil @Read-Only Optional copy of the position where the damage occurred, or if not applicable, the source entity’s position.
DamageSource = {}
