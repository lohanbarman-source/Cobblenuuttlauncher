---@meta
--- A 3-dimensional numerical vector.
---@class Vec3
---@operator add(Vec3): Vec3
---@operator sub(Vec3): Vec3
---@operator mul(number): Vec3
---@operator mul(Vec3): number
---@operator unm: Vec3
---@operator concat(Vec3): string
---@field x number
---@field y number
---@field z number
Vec3 = {}

--- Initializes a new vector.
---@param x number
---@param y number
---@param z number
---@return Vec3
function Vec3:new(x, y, z) end

--- Convenient constructor for creating a new vector. Equivalent to `Vec3:new(x, y, z)`.
---@param x number
---@param y number
---@param z number
---@return Vec3
function Vec3(x,y,z) end

--- Returns a string representation of this vector.
---@return string
function Vec3:tostring() end

--- Metamethod for `tostring(vec)` or string concatenation.
---@param self Vec3
---@return string
function Vec3.__tostring(self) end

--- Returns a new vector that is the sum of this vector and another.
---@param other Vec3
---@return Vec3
function Vec3:add(other) end

--- Metamethod for `vec1 + vec2`.
---@param v1 Vec3
---@param v2 Vec3
---@return Vec3
function Vec3.__add(v1, v2) end

--- Returns a new vector that is the difference between this vector and another.
---@param other Vec3
---@return Vec3
function Vec3:subtract(other) end

--- Metamethod for `vec1 - vec2`.
---@param v1 Vec3
---@param v2 Vec3
---@return Vec3
function Vec3.__sub(v1, v2) end

--- Returns the squared magnitude of this vector.
---@return number
function Vec3:sqrMagnitude() end

--- Returns the magnitude (length) of this vector.
---@return number
function Vec3:magnitude() end

--- Returns the dot product of this vector and another.
---@param other Vec3
---@return number
function Vec3:dotProduct(other) end

--- Scales this vector by a scalar value.
---@param factor number
---@return Vec3
function Vec3:scale(factor) end

--- Metamethod for `vec * scalar` or `vec1 * vec2` (dot product).
---@param a Vec3|number
---@param b Vec3|number
---@return Vec3|number
function Vec3.__mul(a, b) end

--- Inverts this vector (negates all components).
---@return Vec3
function Vec3:invert() end

--- Metamethod for `-vec`.
---@param v Vec3
---@return Vec3
function Vec3.__unm(v) end

--- Metamethod for `vec1 .. vec2` (string concatenation).
---@param a any
---@param b any
---@return string
function Vec3.__concat(a, b) end

--- Compares two vectors for equality.
---@param a Vec3
---@param b Vec3
---@return boolean
function Vec3.__eq(a, b) end

--- Normalizes this vector to unit length.
---@return Vec3
function Vec3:normalize() end

--- Floors all components of the vector.
---@return Vec3
function Vec3:floor() end

--- Calculates the chunk coordinates (assuming 16-unit chunks).
---@return number, number
function Vec3:chunk() end
