--sh_inventory
-- inventory methods

function ERP.DecodeInventory(str)
	if not str then return {} end

	local t ={}
	for k,v in ipairs(string.Explode("]",str,false))do
		t[#t+1] = {}
		for k,v in ipairs(string.Explode("[",v,false))do
			if v[1] and v[2] then
				t[#t].item = v[1];
				t[#t].pos = {};
				t[#t].pos.x = string.Explode(",",v[2],false)[1];
				t[#t].pos.y = string.Explode(",",v[2],false)[2];
			end
		end
	end
	return t;
end
function ERP.EncodeInventory(tbl)
	if not tbl or not tbl[1] then return end

	local s = ""
	for k,v in ipairs(tbl)do
		if not v.item or not v.pos or not v.pos.x or not v.pos.y then continue end

		s = s..v.item.."["..v.pos.x..","..v.pos.y;
		if tbl[k+1]then
		s=s.."]"
		end
	end
	return s;
end
local PLAYER = FindMetaTable("Player");


function PLAYER:GiveItem(id,x,y)
	if not self:IsLoaded() then return end
	
	self.character.inventory[#self.character.inventory+1] = {item = id, pos = {x=x,y=x}};
	self:SaveCharacter();
end