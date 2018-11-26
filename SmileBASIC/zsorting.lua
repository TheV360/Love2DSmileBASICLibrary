-- Simple z-sorting

ZSort = {
	Items = {}
}

function ZSort.zSort(arr)
	table.sort(arr, ZSort.sortFunction)
end
function ZSort.sortFunction(a, b) return b.z < a.z end

function ZSort.clear()
	ZSort.Items = {}
end
function ZSort.add(i)
	table.insert(ZSort.Items, i)
end
function ZSort.flush()
	local i
	
	ZSort.zSort(ZSort.Items)
	
	Sprites.startBatch()
	for i = 1, #ZSort.Items do
		--- if (not Sprites.InBatch) and ZSort.Items[i].type == "sprite" then
		--- 	Sprites.startBatch()
		--- end
		if ZSort.Items[i].type ~= "sprite" then
			Sprites.endBatch()
			Sprites.startBatch()
		end
		ZSort.Items[i]:draw()
	end
	if Sprites.InBatch then Sprites.endBatch() end
end
