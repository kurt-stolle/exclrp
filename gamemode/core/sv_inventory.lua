local INV = FindMetaTable("Inventory")

-- Always chck whether the item fits and is valid before calling this!
function INV:AddItem(item,x,y)
	if not ERP.ValidItem(item) then return error("Invalid item") end

	local grid = self:GetGrid();

	if not grid[x] then grid[x] = {} end

	grid[x][y] = item:GetName()
end
