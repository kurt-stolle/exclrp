AddCSLuaFile();

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "EXCLRP ITEM"
ENT.Author = "Excl"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Item = 0

function ENT:Initialize()
	self._bItemLoaded=SERVER;

	self:SetModel(self:GetItem()._model);

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject();
	if phys and phys:IsValid() then
		phys:Wake();
	end
end

function ENT:GetItem()
	return ERP.Items[self.Item];
end

function ENT:GetClass()
	return "excl_object";
end

if CLIENT then
	net.Receive("ERP.Item.UseTransmit",function()
		local ent=net.ReadEntity()

		if not IsValid(ent) or ent:GetClass() ~= "excl_object" then return end

		local opts={}
		for k,v in pairs(ent:GetItem()._interactions)do
			opts[#opts+1]={text=k,func=v}
		end

		ERP:CreateActionMenu(ent:LocalToWorld(ent:OBBCenter()),opts)
	end)
elseif SERVER then
	util.AddNetworkString("ERP.Item.UseTransmit")

	function ENT:Use(p)
		if not IsValid(p) or not p.IsPlayer or not p:IsPlayer() then return end

		net.Start("ERP.Item.UseTransmit")
		net.WriteEntity(self)
		net.Send(p)
	end
end
