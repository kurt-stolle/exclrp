--sh_inventory
-- inventory methods

function GM:DecodeInventory(str)
	local t ={}
	for k,v in pairs(string.Explode("]",str))do
		t[#t+1] = {}
		for k,v in pairs(string.Explode("[",v))do
			if v[1] and v[2] then
				t[#t].item = v[1];
				t[#t].pos = {};
				t[#t].pos.x = string.Explode(",",v[2])[1];
				t[#t].pos.y = string.Explode(",",v[2])[2];
			end
		end
	end
	return t;
end
function GM:EncodeInventory(tbl)
	local s = ""
	for k,v in pairs(tbl or {})do
		s = s..v.item.."["..v.pos.x..","..v.pos.y;
		if tbl[k+1]then
		s=s.."]"
		end
	end
	return s;
end
local pmeta = FindMetaTable("Player");


function pmeta:GiveItem(id,x,y)
	if not self:IsLoaded() then return end
	
	self.character.inventory[#self.character.inventory+1] = {item = id, pos = {x=x,y=x}};
	self:SaveCharacter();
end