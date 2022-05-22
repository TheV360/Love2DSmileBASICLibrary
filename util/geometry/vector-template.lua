⊘first{
local ffi = require("ffi")
local vecs = { float = {}, integer = {} }
}
ffi.cdef[[
typedef struct {
	⊘i{int}⊘f{double} ⊠, {⊗⊗c};
} v_vector⊗f;
]]

local Vector⊗f
local vector⊗f_mt_index = {
	toString = function(self)
		return "Vector⊗f (⊗V) (⊠ ", {⊗⊗c: " .. self.⊗⊗c .. } ")" --"
	end,
	
	zero = function() return Vector⊗f(⊠, {0}) end,
	one = function() return Vector⊗f(⊠, {1}) end,
	
	unpack = function(self) return ⊠, {self.⊗⊗c} end,
	
	⊘i{toFloat = function(self) return Vector⊗cf(⊠, {self.⊗⊗c}) end,
	}⊘f{toInt = function(self) return Vector⊗ci(⊠, {self.⊗⊗c}) end,
	
	floor = function(self) return Vector⊗f(⊠, {math.floor(self.⊗⊗c)}) end,
	round = function(self) return Vector⊗f(⊠, {math.floor(self.⊗⊗c + 0.5)}) end, -- todo: hmm
	ceil = function(self) return Vector⊗f(⊠, {math.ceil(self.⊗⊗c)}) end,
	}
	abs = function(self) return Vector⊗f(⊠, {math.abs(self.⊗⊗c)}) end,
	
	unm = function(self) return Vector⊗f(⊠, {-self.⊗⊗c}) end,
	
	adds = function(self, scalar) return Vector⊗f(⊠, {self.⊗⊗c + scalar}) end,
	subs = function(self, scalar) return Vector⊗f(⊠, {self.⊗⊗c - scalar}) end,
	muls = function(self, scalar) return Vector⊗f(⊠, {self.⊗⊗c * scalar}) end,
	divs = function(self, scalar) return Vector⊗f(⊠, {self.⊗⊗c / scalar}) end,
	
	addv = function(self, other) return Vector⊗f(⊠, {self.⊗⊗c + other.⊗⊗c}) end,
	subv = function(self, other) return Vector⊗f(⊠, {self.⊗⊗c - other.⊗⊗c}) end,
	mulv = function(self, other) return Vector⊗f(⊠, {self.⊗⊗c * other.⊗⊗c}) end,
	divv = function(self, other) return Vector⊗f(⊠, {self.⊗⊗c / other.⊗⊗c}) end,
	
	add = function(self, other) return type(other) == "number" and self:adds(other) or self:addv(other) end,
	sub = function(self, other) return type(other) == "number" and self:subs(other) or self:subv(other) end,
	mul = function(self, other) return type(other) == "number" and self:muls(other) or self:mulv(other) end,
	div = function(self, other) return type(other) == "number" and self:divs(other) or self:divv(other) end,
	
	recip = function(self) return Vector⊗f(⊠, {1 / self.⊗⊗c}) end,
	
	clamp = function(self, low, high)
		return Vector⊗f(
			⊠,
			{math.min(math.max(low.⊗⊗c, self.⊗⊗c), high.⊗⊗c)}
		)
	end,
	
	dot = function(self, other) return ⊠ + {(self.⊗⊗c * other.⊗⊗c)} end,
	⊘3{cross = function(self, other)
		return Vector⊗f(
			self.y * other.z - self.z * other.y,
			self.z * other.x - self.x * other.z,
			self.x * other.y - self.y * other.x
		)
	end,
	}
	squaredMagnitude = function(self) return ⊠ + {(self.⊗⊗c * self.⊗⊗c)} end,
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
	⊘2{
	angle = function(self)
		return math.atan(self.y, self.x)
	end,
	angleBetween = function(self, other)
		return math.atan(other.y - self.y, other.x - self.x)
	end,
	rotate = function(self, rad)
		local s, c = math.sin(rad), math.cos(rad)
		return Vector⊗f(self.x * c - self.y * s, self.x * s + self.y * c)
	end,
	}
	getSector = function(self)
		return (
			⊠ +
			{(self.⊗⊗c < 0 and bit.lshift(1, ⊗⊗i) or 0)}
		)
	end,
	toSector0 = function(self)
		return self:abs()
	end,
	toSector = function(self, sector)
		return Vector⊗f(
			⊠,
			{self.⊗⊗c * (bit.band(bit.rshift(sector, ⊗⊗i), 1) > 0 and -1 or 1)}
		)
	end,
}
local vector⊗f_mt = {
	__unm = vector⊗f_mt_index.unm,
	__add = vector⊗f_mt_index.add,
	__sub = vector⊗f_mt_index.sub,
	__mul = vector⊗f_mt_index.mul,
	__div = vector⊗f_mt_index.div,
	__len = vector⊗f_mt_index.magnitude,
	__tostring = vector⊗f_mt_index.toString,
	__index = vector⊗f_mt_index,
}
Vector⊗f = ffi.metatype("v_vector⊗f", vector⊗f_mt)
table.insert(vecs.⊗V, Vector⊗f)
⊘last{
return vecs}
