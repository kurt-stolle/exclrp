local INV = FindMetaTable("Inventory")

-- Always chck whether the item fits and is valid before calling this!
function INV:AddItem(item,x,y)
	if not ERP.ValidItem(item) then return error("Invalid item") end

	local grid = self:GetGrid();

	if not grid[x] then grid[x] = {} end

	grid[x][y] = {item=item:GetName(),data=item._data}
end
function INV:RemoveItem(item,x,y)
	if not self:HasItemAt(item:GetName(),x,y) then return end

	self:GetGrid()[x][y]=nil;
end
function INV:MoveItem(item,xOld,yOld,xNew,yNew)
	if not ERP.ValidItem(item) then return error("Invalid item") end
	if not self:HasItemAt(item:GetName(),xOld,yOld) or not tobool(self:FitItemAt(item,xNew,yNew)) then return ES.DebugPrint("Failed item move") end

	self:RemoveItem(item,xOld,yOld)
	self:AddItem(item,xNew,yNew)
end
