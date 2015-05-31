--sh_inventory

-- vars
local INV = FindMetaTable("Inventory")

-- Decoding
function ERP.DecodeInventory(str)
	local tab=util.JSONToTable(str or "[]");

	setmetatable(tab,INV)
	INV.__index=INV;

	return tab
end
function ERP.EncodeInventory(tbl)
	return util.TableToJSON(tbl or {})
end

-- Meta
function ERP.Inventory()
	local i={}
	setmetatable(i,INV)
	INV.__index=INV;

	i.grid={}
	i.w=1;
	i.h=1;

	return i;
end

AccessorFunc(INV,"w","Width",FORCE_NUMBER)
AccessorFunc(INV,"h","Height",FORCE_NUMBER)
function INV:GetSize()
	return self.w,self.h;
end
function INV:GetItems()
	local items={};
	for x,_t in pairs(self.grid) do
		for y,item in pairs(_t) do
			if ES.Items[item] then
				table.insert(items,ES.Items[item]);
			end
		end
	end
	return items;
end
function INV:HasItem(item)
	return table.HasValue(self:GetItems(),item);
end
function INV:GetGrid()
	return self.grid;
end
function INV:FitItem(item)
	if not ERP.ValidItem(item) then return end

	local w,h = item:GetInventorySize();
	local grid = self:GetGrid()


	for x=1,w do
		for y=1,h do
			if not grid[x] or not grid[x][y] then
				local nope=false;
				for _x=x,x+item:GetInventoryWidth()-1 do
					for _y=y,y+item:GetInventoryHeight()-1 do
						if grid[x] and grid[x][y] then
							local nope=true;
							break;
						end
					end
				end
				if not nope then
					return x,y;
				end
			end
		end
	end

	return -1,-1
end
