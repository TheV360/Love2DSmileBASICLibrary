-- Generated file.

local ffi = require("ffi")
local vecs = { float = {}, integer = {} }

ffi.cdef[[
typedef struct {
	double x, y;
} v_vector2f;
]]

local Vector2f
local vector2f_mt_index = {
	toString = function(self)
		return "Vector2f (float) (x: " .. self.x ..  ", y: " .. self.y ..  ")" --"
	end,
	
	zero = function() return Vector2f(0, 0) end,
	one = function() return Vector2f(1, 1) end,
	
	unpack = function(self) return self.x, self.y end,
	
	toInt = function(self) return Vector2i(self.x, self.y) end,
	
	floor = function(self) return Vector2f(math.floor(self.x), math.floor(self.y)) end,
	round = function(self) return Vector2f(math.floor(self.x + 0.5), math.floor(self.y + 0.5)) end, -- todo: hmm
	ceil = function(self) return Vector2f(math.ceil(self.x), math.ceil(self.y)) end,
	
	abs = function(self) return Vector2f(math.abs(self.x), math.abs(self.y)) end,
	
	unm = function(self) return Vector2f(-self.x, -self.y) end,
	
	adds = function(self, scalar) return Vector2f(self.x + scalar, self.y + scalar) end,
	subs = function(self, scalar) return Vector2f(self.x - scalar, self.y - scalar) end,
	muls = function(self, scalar) return Vector2f(self.x * scalar, self.y * scalar) end,
	divs = function(self, scalar) return Vector2f(self.x / scalar, self.y / scalar) end,
	
	addv = function(self, other) return Vector2f(self.x + other.x, self.y + other.y) end,
	subv = function(self, other) return Vector2f(self.x - other.x, self.y - other.y) end,
	mulv = function(self, other) return Vector2f(self.x * other.x, self.y * other.y) end,
	divv = function(self, other) return Vector2f(self.x / other.x, self.y / other.y) end,
	
	add = function(self, other) return type(other) == "number" and self:adds(other) or self:addv(other) end,
	sub = function(self, other) return type(other) == "number" and self:subs(other) or self:subv(other) end,
	mul = function(self, other) return type(other) == "number" and self:muls(other) or self:mulv(other) end,
	div = function(self, other) return type(other) == "number" and self:divs(other) or self:divv(other) end,
	
	recip = function(self) return Vector2f(1 / self.x, 1 / self.y) end,
	
	clamp = function(self, low, high)
		return Vector2f(
			math.min(math.max(low.x, self.x), high.x),
			math.min(math.max(low.y, self.y), high.y)
		)
	end,
	
	dot = function(self, other) return (self.x * other.x) + (self.y * other.y) end,
	
	squaredMagnitude = function(self) return (self.x * self.x) + (self.y * self.y) end,
	magnitude = function(self) return math.sqrt(self:squaredMagnitude()) end,
	normalize = function(self) return self:divs(self:magnitude()) end,
	
	lerp = function(self, other, progress)
		return self * (-progress + 1) + other * progress
	end,
	invLerp = function(self, other, progress)
		return (-self + progress) / (other - self)
	end,
	
	project = function(self, other)
		return (other:dot(self) / other:magnitude()) * other
	end,
	reflect = function(self, other)
		return self - (other * self:dot(other) * 2)
	end,
	
	angle = function(self)
		return math.atan(self.y, self.x)
	end,
	angleBetween = function(self, other)
		return math.atan(other.y - self.y, other.x - self.x)
	end,
	rotate = function(self, rad)
		local s, c = math.sin(rad), math.cos(rad)
		return Vector2f(self.x * c - self.y * s, self.x * s + self.y * c)
	end,
	
	getSector = function(self)
		return (
			(self.x < 0 and bit.lshift(1, 0) or 0) +
			(self.y < 0 and bit.lshift(1, 1) or 0)
		)
	end,
	toSector0 = function(self)
		return self:abs()
	end,
	toSector = function(self, sector)
		return Vector2f(
			self.x * (bit.band(bit.rshift(sector, 0), 1) > 0 and -1 or 1),
			self.y * (bit.band(bit.rshift(sector, 1), 1) > 0 and -1 or 1)
		)
	end,
}
local vector2f_mt = {
	__unm = vector2f_mt_index.unm,
	__add = vector2f_mt_index.add,
	__sub = vector2f_mt_index.sub,
	__mul = vector2f_mt_index.mul,
	__div = vector2f_mt_index.div,
	__len = vector2f_mt_index.magnitude,
	__tostring = vector2f_mt_index.toString,
	__index = vector2f_mt_index,
}
Vector2f = ffi.metatype("v_vector2f", vector2f_mt)
table.insert(vecs.float, Vector2f)

-- Generated file.

ffi.cdef[[
typedef struct {
	int x, y;
} v_vector2i;
]]

local Vector2i
local vector2i_mt_index = {
	toString = function(self)
		return "Vector2i (integer) (x: " .. self.x ..  ", y: " .. self.y ..  ")" --"
	end,
	
	zero = function() return Vector2i(0, 0) end,
	one = function() return Vector2i(1, 1) end,
	
	unpack = function(self) return self.x, self.y end,
	
	toFloat = function(self) return Vector2f(self.x, self.y) end,
	
	abs = function(self) return Vector2i(math.abs(self.x), math.abs(self.y)) end,
	
	unm = function(self) return Vector2i(-self.x, -self.y) end,
	
	adds = function(self, scalar) return Vector2i(self.x + scalar, self.y + scalar) end,
	subs = function(self, scalar) return Vector2i(self.x - scalar, self.y - scalar) end,
	muls = function(self, scalar) return Vector2i(self.x * scalar, self.y * scalar) end,
	divs = function(self, scalar) return Vector2i(self.x / scalar, self.y / scalar) end,
	
	addv = function(self, other) return Vector2i(self.x + other.x, self.y + other.y) end,
	subv = function(self, other) return Vector2i(self.x - other.x, self.y - other.y) end,
	mulv = function(self, other) return Vector2i(self.x * other.x, self.y * other.y) end,
	divv = function(self, other) return Vector2i(self.x / other.x, self.y / other.y) end,
	
	add = function(self, other) return type(other) == "number" and self:adds(other) or self:addv(other) end,
	sub = function(self, other) return type(other) == "number" and self:subs(other) or self:subv(other) end,
	mul = function(self, other) return type(other) == "number" and self:muls(other) or self:mulv(other) end,
	div = function(self, other) return type(other) == "number" and self:divs(other) or self:divv(other) end,
	
	recip = function(self) return Vector2i(1 / self.x, 1 / self.y) end,
	
	clamp = function(self, low, high)
		return Vector2i(
			math.min(math.max(low.x, self.x), high.x),
			math.min(math.max(low.y, self.y), high.y)
		)
	end,
	
	dot = function(self, other) return (self.x * other.x) + (self.y * other.y) end,
	
	squaredMagnitude = function(self) return (self.x * self.x) + (self.y * self.y) end,
	magnitude = function(self) return math.sqrt(self:squaredMagnitude()) end,
	normalize = function(self) return self:divs(self:magnitude()) end,
	
	lerp = function(self, other, progress)
		return self * (-progress + 1) + other * progress
	end,
	invLerp = function(self, other, progress)
		return (-self + progress) / (other - self)
	end,
	
	project = function(self, other)
		return (other:dot(self) / other:magnitude()) * other
	end,
	reflect = function(self, other)
		return self - (other * self:dot(other) * 2)
	end,
	
	angle = function(self)
		return math.atan(self.y, self.x)
	end,
	angleBetween = function(self, other)
		return math.atan(other.y - self.y, other.x - self.x)
	end,
	rotate = function(self, rad)
		local s, c = math.sin(rad), math.cos(rad)
		return Vector2i(self.x * c - self.y * s, self.x * s + self.y * c)
	end,
	
	getSector = function(self)
		return (
			(self.x < 0 and bit.lshift(1, 0) or 0) +
			(self.y < 0 and bit.lshift(1, 1) or 0)
		)
	end,
	toSector0 = function(self)
		return self:abs()
	end,
	toSector = function(self, sector)
		return Vector2i(
			self.x * (bit.band(bit.rshift(sector, 0), 1) > 0 and -1 or 1),
			self.y * (bit.band(bit.rshift(sector, 1), 1) > 0 and -1 or 1)
		)
	end,
}
local vector2i_mt = {
	__unm = vector2i_mt_index.unm,
	__add = vector2i_mt_index.add,
	__sub = vector2i_mt_index.sub,
	__mul = vector2i_mt_index.mul,
	__div = vector2i_mt_index.div,
	__len = vector2i_mt_index.magnitude,
	__tostring = vector2i_mt_index.toString,
	__index = vector2i_mt_index,
}
Vector2i = ffi.metatype("v_vector2i", vector2i_mt)
table.insert(vecs.integer, Vector2i)

-- Generated file.

ffi.cdef[[
typedef struct {
	double x, y, z;
} v_vector3f;
]]

local Vector3f
local vector3f_mt_index = {
	toString = function(self)
		return "Vector3f (float) (x: " .. self.x ..  ", y: " .. self.y ..  ", z: " .. self.z ..  ")" --"
	end,
	
	zero = function() return Vector3f(0, 0, 0) end,
	one = function() return Vector3f(1, 1, 1) end,
	
	unpack = function(self) return self.x, self.y, self.z end,
	
	toInt = function(self) return Vector3i(self.x, self.y, self.z) end,
	
	floor = function(self) return Vector3f(math.floor(self.x), math.floor(self.y), math.floor(self.z)) end,
	round = function(self) return Vector3f(math.floor(self.x + 0.5), math.floor(self.y + 0.5), math.floor(self.z + 0.5)) end, -- todo: hmm
	ceil = function(self) return Vector3f(math.ceil(self.x), math.ceil(self.y), math.ceil(self.z)) end,
	
	abs = function(self) return Vector3f(math.abs(self.x), math.abs(self.y), math.abs(self.z)) end,
	
	unm = function(self) return Vector3f(-self.x, -self.y, -self.z) end,
	
	adds = function(self, scalar) return Vector3f(self.x + scalar, self.y + scalar, self.z + scalar) end,
	subs = function(self, scalar) return Vector3f(self.x - scalar, self.y - scalar, self.z - scalar) end,
	muls = function(self, scalar) return Vector3f(self.x * scalar, self.y * scalar, self.z * scalar) end,
	divs = function(self, scalar) return Vector3f(self.x / scalar, self.y / scalar, self.z / scalar) end,
	
	addv = function(self, other) return Vector3f(self.x + other.x, self.y + other.y, self.z + other.z) end,
	subv = function(self, other) return Vector3f(self.x - other.x, self.y - other.y, self.z - other.z) end,
	mulv = function(self, other) return Vector3f(self.x * other.x, self.y * other.y, self.z * other.z) end,
	divv = function(self, other) return Vector3f(self.x / other.x, self.y / other.y, self.z / other.z) end,
	
	add = function(self, other) return type(other) == "number" and self:adds(other) or self:addv(other) end,
	sub = function(self, other) return type(other) == "number" and self:subs(other) or self:subv(other) end,
	mul = function(self, other) return type(other) == "number" and self:muls(other) or self:mulv(other) end,
	div = function(self, other) return type(other) == "number" and self:divs(other) or self:divv(other) end,
	
	recip = function(self) return Vector3f(1 / self.x, 1 / self.y, 1 / self.z) end,
	
	clamp = function(self, low, high)
		return Vector3f(
			math.min(math.max(low.x, self.x), high.x),
			math.min(math.max(low.y, self.y), high.y),
			math.min(math.max(low.z, self.z), high.z)
		)
	end,
	
	dot = function(self, other) return (self.x * other.x) + (self.y * other.y) + (self.z * other.z) end,
	cross = function(self, other)
		return Vector3f(
			self.y * other.z - self.z * other.y,
			self.z * other.x - self.x * other.z,
			self.x * other.y - self.y * other.x
		)
	end,
	
	squaredMagnitude = function(self) return (self.x * self.x) + (self.y * self.y) + (self.z * self.z) end,
	magnitude = function(self) return math.sqrt(self:squaredMagnitude()) end,
	normalize = function(self) return self:divs(self:magnitude()) end,
	
	lerp = function(self, other, progress)
		return self * (-progress + 1) + other * progress
	end,
	invLerp = function(self, other, progress)
		return (-self + progress) / (other - self)
	end,
	
	project = function(self, other)
		return (other:dot(self) / other:magnitude()) * other
	end,
	reflect = function(self, other)
		return self - (other * self:dot(other) * 2)
	end,
	
	getSector = function(self)
		return (
			(self.x < 0 and bit.lshift(1, 0) or 0) +
			(self.y < 0 and bit.lshift(1, 1) or 0) +
			(self.z < 0 and bit.lshift(1, 2) or 0)
		)
	end,
	toSector0 = function(self)
		return self:abs()
	end,
	toSector = function(self, sector)
		return Vector3f(
			self.x * (bit.band(bit.rshift(sector, 0), 1) > 0 and -1 or 1),
			self.y * (bit.band(bit.rshift(sector, 1), 1) > 0 and -1 or 1),
			self.z * (bit.band(bit.rshift(sector, 2), 1) > 0 and -1 or 1)
		)
	end,
}
local vector3f_mt = {
	__unm = vector3f_mt_index.unm,
	__add = vector3f_mt_index.add,
	__sub = vector3f_mt_index.sub,
	__mul = vector3f_mt_index.mul,
	__div = vector3f_mt_index.div,
	__len = vector3f_mt_index.magnitude,
	__tostring = vector3f_mt_index.toString,
	__index = vector3f_mt_index,
}
Vector3f = ffi.metatype("v_vector3f", vector3f_mt)
table.insert(vecs.float, Vector3f)

-- Generated file.

ffi.cdef[[
typedef struct {
	int x, y, z;
} v_vector3i;
]]

local Vector3i
local vector3i_mt_index = {
	toString = function(self)
		return "Vector3i (integer) (x: " .. self.x ..  ", y: " .. self.y ..  ", z: " .. self.z ..  ")" --"
	end,
	
	zero = function() return Vector3i(0, 0, 0) end,
	one = function() return Vector3i(1, 1, 1) end,
	
	unpack = function(self) return self.x, self.y, self.z end,
	
	toFloat = function(self) return Vector3f(self.x, self.y, self.z) end,
	
	abs = function(self) return Vector3i(math.abs(self.x), math.abs(self.y), math.abs(self.z)) end,
	
	unm = function(self) return Vector3i(-self.x, -self.y, -self.z) end,
	
	adds = function(self, scalar) return Vector3i(self.x + scalar, self.y + scalar, self.z + scalar) end,
	subs = function(self, scalar) return Vector3i(self.x - scalar, self.y - scalar, self.z - scalar) end,
	muls = function(self, scalar) return Vector3i(self.x * scalar, self.y * scalar, self.z * scalar) end,
	divs = function(self, scalar) return Vector3i(self.x / scalar, self.y / scalar, self.z / scalar) end,
	
	addv = function(self, other) return Vector3i(self.x + other.x, self.y + other.y, self.z + other.z) end,
	subv = function(self, other) return Vector3i(self.x - other.x, self.y - other.y, self.z - other.z) end,
	mulv = function(self, other) return Vector3i(self.x * other.x, self.y * other.y, self.z * other.z) end,
	divv = function(self, other) return Vector3i(self.x / other.x, self.y / other.y, self.z / other.z) end,
	
	add = function(self, other) return type(other) == "number" and self:adds(other) or self:addv(other) end,
	sub = function(self, other) return type(other) == "number" and self:subs(other) or self:subv(other) end,
	mul = function(self, other) return type(other) == "number" and self:muls(other) or self:mulv(other) end,
	div = function(self, other) return type(other) == "number" and self:divs(other) or self:divv(other) end,
	
	recip = function(self) return Vector3i(1 / self.x, 1 / self.y, 1 / self.z) end,
	
	clamp = function(self, low, high)
		return Vector3i(
			math.min(math.max(low.x, self.x), high.x),
			math.min(math.max(low.y, self.y), high.y),
			math.min(math.max(low.z, self.z), high.z)
		)
	end,
	
	dot = function(self, other) return (self.x * other.x) + (self.y * other.y) + (self.z * other.z) end,
	cross = function(self, other)
		return Vector3i(
			self.y * other.z - self.z * other.y,
			self.z * other.x - self.x * other.z,
			self.x * other.y - self.y * other.x
		)
	end,
	
	squaredMagnitude = function(self) return (self.x * self.x) + (self.y * self.y) + (self.z * self.z) end,
	magnitude = function(self) return math.sqrt(self:squaredMagnitude()) end,
	normalize = function(self) return self:divs(self:magnitude()) end,
	
	lerp = function(self, other, progress)
		return self * (-progress + 1) + other * progress
	end,
	invLerp = function(self, other, progress)
		return (-self + progress) / (other - self)
	end,
	
	project = function(self, other)
		return (other:dot(self) / other:magnitude()) * other
	end,
	reflect = function(self, other)
		return self - (other * self:dot(other) * 2)
	end,
	
	getSector = function(self)
		return (
			(self.x < 0 and bit.lshift(1, 0) or 0) +
			(self.y < 0 and bit.lshift(1, 1) or 0) +
			(self.z < 0 and bit.lshift(1, 2) or 0)
		)
	end,
	toSector0 = function(self)
		return self:abs()
	end,
	toSector = function(self, sector)
		return Vector3i(
			self.x * (bit.band(bit.rshift(sector, 0), 1) > 0 and -1 or 1),
			self.y * (bit.band(bit.rshift(sector, 1), 1) > 0 and -1 or 1),
			self.z * (bit.band(bit.rshift(sector, 2), 1) > 0 and -1 or 1)
		)
	end,
}
local vector3i_mt = {
	__unm = vector3i_mt_index.unm,
	__add = vector3i_mt_index.add,
	__sub = vector3i_mt_index.sub,
	__mul = vector3i_mt_index.mul,
	__div = vector3i_mt_index.div,
	__len = vector3i_mt_index.magnitude,
	__tostring = vector3i_mt_index.toString,
	__index = vector3i_mt_index,
}
Vector3i = ffi.metatype("v_vector3i", vector3i_mt)
table.insert(vecs.integer, Vector3i)

-- Generated file.

ffi.cdef[[
typedef struct {
	double x, y, z, w;
} v_vector4f;
]]

local Vector4f
local vector4f_mt_index = {
	toString = function(self)
		return "Vector4f (float) (x: " .. self.x ..  ", y: " .. self.y ..  ", z: " .. self.z ..  ", w: " .. self.w ..  ")" --"
	end,
	
	zero = function() return Vector4f(0, 0, 0, 0) end,
	one = function() return Vector4f(1, 1, 1, 1) end,
	
	unpack = function(self) return self.x, self.y, self.z, self.w end,
	
	toInt = function(self) return Vector4i(self.x, self.y, self.z, self.w) end,
	
	floor = function(self) return Vector4f(math.floor(self.x), math.floor(self.y), math.floor(self.z), math.floor(self.w)) end,
	round = function(self) return Vector4f(math.floor(self.x + 0.5), math.floor(self.y + 0.5), math.floor(self.z + 0.5), math.floor(self.w + 0.5)) end, -- todo: hmm
	ceil = function(self) return Vector4f(math.ceil(self.x), math.ceil(self.y), math.ceil(self.z), math.ceil(self.w)) end,
	
	abs = function(self) return Vector4f(math.abs(self.x), math.abs(self.y), math.abs(self.z), math.abs(self.w)) end,
	
	unm = function(self) return Vector4f(-self.x, -self.y, -self.z, -self.w) end,
	
	adds = function(self, scalar) return Vector4f(self.x + scalar, self.y + scalar, self.z + scalar, self.w + scalar) end,
	subs = function(self, scalar) return Vector4f(self.x - scalar, self.y - scalar, self.z - scalar, self.w - scalar) end,
	muls = function(self, scalar) return Vector4f(self.x * scalar, self.y * scalar, self.z * scalar, self.w * scalar) end,
	divs = function(self, scalar) return Vector4f(self.x / scalar, self.y / scalar, self.z / scalar, self.w / scalar) end,
	
	addv = function(self, other) return Vector4f(self.x + other.x, self.y + other.y, self.z + other.z, self.w + other.w) end,
	subv = function(self, other) return Vector4f(self.x - other.x, self.y - other.y, self.z - other.z, self.w - other.w) end,
	mulv = function(self, other) return Vector4f(self.x * other.x, self.y * other.y, self.z * other.z, self.w * other.w) end,
	divv = function(self, other) return Vector4f(self.x / other.x, self.y / other.y, self.z / other.z, self.w / other.w) end,
	
	add = function(self, other) return type(other) == "number" and self:adds(other) or self:addv(other) end,
	sub = function(self, other) return type(other) == "number" and self:subs(other) or self:subv(other) end,
	mul = function(self, other) return type(other) == "number" and self:muls(other) or self:mulv(other) end,
	div = function(self, other) return type(other) == "number" and self:divs(other) or self:divv(other) end,
	
	recip = function(self) return Vector4f(1 / self.x, 1 / self.y, 1 / self.z, 1 / self.w) end,
	
	clamp = function(self, low, high)
		return Vector4f(
			math.min(math.max(low.x, self.x), high.x),
			math.min(math.max(low.y, self.y), high.y),
			math.min(math.max(low.z, self.z), high.z),
			math.min(math.max(low.w, self.w), high.w)
		)
	end,
	
	dot = function(self, other) return (self.x * other.x) + (self.y * other.y) + (self.z * other.z) + (self.w * other.w) end,
	
	squaredMagnitude = function(self) return (self.x * self.x) + (self.y * self.y) + (self.z * self.z) + (self.w * self.w) end,
	magnitude = function(self) return math.sqrt(self:squaredMagnitude()) end,
	normalize = function(self) return self:divs(self:magnitude()) end,
	
	lerp = function(self, other, progress)
		return self * (-progress + 1) + other * progress
	end,
	invLerp = function(self, other, progress)
		return (-self + progress) / (other - self)
	end,
	
	project = function(self, other)
		return (other:dot(self) / other:magnitude()) * other
	end,
	reflect = function(self, other)
		return self - (other * self:dot(other) * 2)
	end,
	
	getSector = function(self)
		return (
			(self.x < 0 and bit.lshift(1, 0) or 0) +
			(self.y < 0 and bit.lshift(1, 1) or 0) +
			(self.z < 0 and bit.lshift(1, 2) or 0) +
			(self.w < 0 and bit.lshift(1, 3) or 0)
		)
	end,
	toSector0 = function(self)
		return self:abs()
	end,
	toSector = function(self, sector)
		return Vector4f(
			self.x * (bit.band(bit.rshift(sector, 0), 1) > 0 and -1 or 1),
			self.y * (bit.band(bit.rshift(sector, 1), 1) > 0 and -1 or 1),
			self.z * (bit.band(bit.rshift(sector, 2), 1) > 0 and -1 or 1),
			self.w * (bit.band(bit.rshift(sector, 3), 1) > 0 and -1 or 1)
		)
	end,
}
local vector4f_mt = {
	__unm = vector4f_mt_index.unm,
	__add = vector4f_mt_index.add,
	__sub = vector4f_mt_index.sub,
	__mul = vector4f_mt_index.mul,
	__div = vector4f_mt_index.div,
	__len = vector4f_mt_index.magnitude,
	__tostring = vector4f_mt_index.toString,
	__index = vector4f_mt_index,
}
Vector4f = ffi.metatype("v_vector4f", vector4f_mt)
table.insert(vecs.float, Vector4f)

-- Generated file.

ffi.cdef[[
typedef struct {
	int x, y, z, w;
} v_vector4i;
]]

local Vector4i
local vector4i_mt_index = {
	toString = function(self)
		return "Vector4i (integer) (x: " .. self.x ..  ", y: " .. self.y ..  ", z: " .. self.z ..  ", w: " .. self.w ..  ")" --"
	end,
	
	zero = function() return Vector4i(0, 0, 0, 0) end,
	one = function() return Vector4i(1, 1, 1, 1) end,
	
	unpack = function(self) return self.x, self.y, self.z, self.w end,
	
	toFloat = function(self) return Vector4f(self.x, self.y, self.z, self.w) end,
	
	abs = function(self) return Vector4i(math.abs(self.x), math.abs(self.y), math.abs(self.z), math.abs(self.w)) end,
	
	unm = function(self) return Vector4i(-self.x, -self.y, -self.z, -self.w) end,
	
	adds = function(self, scalar) return Vector4i(self.x + scalar, self.y + scalar, self.z + scalar, self.w + scalar) end,
	subs = function(self, scalar) return Vector4i(self.x - scalar, self.y - scalar, self.z - scalar, self.w - scalar) end,
	muls = function(self, scalar) return Vector4i(self.x * scalar, self.y * scalar, self.z * scalar, self.w * scalar) end,
	divs = function(self, scalar) return Vector4i(self.x / scalar, self.y / scalar, self.z / scalar, self.w / scalar) end,
	
	addv = function(self, other) return Vector4i(self.x + other.x, self.y + other.y, self.z + other.z, self.w + other.w) end,
	subv = function(self, other) return Vector4i(self.x - other.x, self.y - other.y, self.z - other.z, self.w - other.w) end,
	mulv = function(self, other) return Vector4i(self.x * other.x, self.y * other.y, self.z * other.z, self.w * other.w) end,
	divv = function(self, other) return Vector4i(self.x / other.x, self.y / other.y, self.z / other.z, self.w / other.w) end,
	
	add = function(self, other) return type(other) == "number" and self:adds(other) or self:addv(other) end,
	sub = function(self, other) return type(other) == "number" and self:subs(other) or self:subv(other) end,
	mul = function(self, other) return type(other) == "number" and self:muls(other) or self:mulv(other) end,
	div = function(self, other) return type(other) == "number" and self:divs(other) or self:divv(other) end,
	
	recip = function(self) return Vector4i(1 / self.x, 1 / self.y, 1 / self.z, 1 / self.w) end,
	
	clamp = function(self, low, high)
		return Vector4i(
			math.min(math.max(low.x, self.x), high.x),
			math.min(math.max(low.y, self.y), high.y),
			math.min(math.max(low.z, self.z), high.z),
			math.min(math.max(low.w, self.w), high.w)
		)
	end,
	
	dot = function(self, other) return (self.x * other.x) + (self.y * other.y) + (self.z * other.z) + (self.w * other.w) end,
	
	squaredMagnitude = function(self) return (self.x * self.x) + (self.y * self.y) + (self.z * self.z) + (self.w * self.w) end,
	magnitude = function(self) return math.sqrt(self:squaredMagnitude()) end,
	normalize = function(self) return self:divs(self:magnitude()) end,
	
	lerp = function(self, other, progress)
		return self * (-progress + 1) + other * progress
	end,
	invLerp = function(self, other, progress)
		return (-self + progress) / (other - self)
	end,
	
	project = function(self, other)
		return (other:dot(self) / other:magnitude()) * other
	end,
	reflect = function(self, other)
		return self - (other * self:dot(other) * 2)
	end,
	
	getSector = function(self)
		return (
			(self.x < 0 and bit.lshift(1, 0) or 0) +
			(self.y < 0 and bit.lshift(1, 1) or 0) +
			(self.z < 0 and bit.lshift(1, 2) or 0) +
			(self.w < 0 and bit.lshift(1, 3) or 0)
		)
	end,
	toSector0 = function(self)
		return self:abs()
	end,
	toSector = function(self, sector)
		return Vector4i(
			self.x * (bit.band(bit.rshift(sector, 0), 1) > 0 and -1 or 1),
			self.y * (bit.band(bit.rshift(sector, 1), 1) > 0 and -1 or 1),
			self.z * (bit.band(bit.rshift(sector, 2), 1) > 0 and -1 or 1),
			self.w * (bit.band(bit.rshift(sector, 3), 1) > 0 and -1 or 1)
		)
	end,
}
local vector4i_mt = {
	__unm = vector4i_mt_index.unm,
	__add = vector4i_mt_index.add,
	__sub = vector4i_mt_index.sub,
	__mul = vector4i_mt_index.mul,
	__div = vector4i_mt_index.div,
	__len = vector4i_mt_index.magnitude,
	__tostring = vector4i_mt_index.toString,
	__index = vector4i_mt_index,
}
Vector4i = ffi.metatype("v_vector4i", vector4i_mt)
table.insert(vecs.integer, Vector4i)

return vecs
