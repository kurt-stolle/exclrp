--sh_inventory
-- inventory methods

function ERP.DecodeInventory(str)
	return util.JSONToTable(str or "[]")
end
function ERP.EncodeInventory(tbl)
	return util.TableToJSON(tbl or {})
end

local PLAYER = FindMetaTable("Player");
function PLAYER:GiveItem(id,x,y)
	if not self:IsLoaded() then return end

	x=tonumber(x)
	y=tonumber(y)

	self.character.inventory[#self.character.inventory+1] = {item = id, pos = {x=x,y=x}};
	self:SaveCharacter();
end
