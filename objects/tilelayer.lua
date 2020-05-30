TileLayer = Object:extend()

function TileLayer:new(tileMap, width, height)
	if not tileMap:is(TileMap) then
		error("Please add a tilemap.")
	end
	self.map = tileMap
	
	self.width = width or 22
	self.height = height or 15
	
	local i, j
	self.tiles = {}
	for j = 0, height - 1 do
		self.tiles[j] = {}
		for i = 0, width - 1 do
			self.tiles[j][i] = {tile = -1}
		end
	end
end

function TileLayer:withinLayer(x, y)
	return x and y
	and x >= 0 and y >= 0
	and x < self.width
	and y < self.height
end

function TileLayer:setTile(x, y, tile)
	if not self:withinLayer(x, y) then return end
	if not self.map.quads[tile] then
		self.map:makeQuad(tile)
	end
	
	self.tiles[y][x].tile = tile
end

function TileLayer:fillArea(x, y, width, height, tile)
	if not self:withinLayer(x, y) then return end
	if not self.map.quads[tile] then
		self.map:makeQuad(tile)
	end
	
	local i, j
	
	for j = 0, height - 1 do
		for i = 0, width - 1 do
			self.tiles[y + j][x + i].tile = tile
		end
	end
end

function TileLayer:draw()
	local i, j
	
	for j = 0, self.height - 1 do
		for i = 0, self.width - 1 do
			if self.tiles[j][i].tile >= 0 then
				self.map.batch:add(
					self.map.quads[self.tiles[j][i].tile],
					i * self.map.size,
					j * self.map.size
				)
			end
		end
	end
end

return TileLayer
