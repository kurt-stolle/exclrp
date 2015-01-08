AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:GetItem()
	return ERP.Items[self.itemid]
end

function ENT:Initialize()	
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self.Entity:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end
end

util.AddNetworkString("ERPHandleItemSpawn")
function ENT:SetItem(id)
	self.itemid = id;

	if self:GetItem() then
		for k,v in pairs(self:GetItem().hooks)do
			if k == "Initialize" then
				v(self);
				return;
			end
			self[k] = v;
		end
	end
	timer.Simple(0,function()
		if self and IsValid(self) and id then
			net.Start("ERPHandleItemSpawn");
			net.WriteEntity(self);
			net.WriteUInt(id,32);
			net.Broadcast(); 
		end
	end)
end
function ENT:Draw()
	self:DrawModel();
end
