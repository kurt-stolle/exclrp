include("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:GetItem()
	return GAMEMODE.Items[self.itemid]
end

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel();
end

function ENT:Think()
end

net.Receive("ERPHandleItemSpawn",function()
	local e = net.ReadEntity();
	local id = net.ReadUInt(32);

	if e and IsValid(e) and e:GetClass() == "excl_object" then
		e.itemid = id;
	

		print("hey?")
		print(e:GetItem())

		if e.dt.itemid and e:GetItem() then
			for k,v in pairs(e:GetItem().hooks)do
				if k == "Initialize" then
					v(e);
					return;
				end
				e[k] = v;
				print("set")
			end
		end
	end
end)