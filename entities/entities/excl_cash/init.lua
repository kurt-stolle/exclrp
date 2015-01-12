AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.Entity:SetModel("models/props/cs_assault/money.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetAmount(1);

	local phys = self.Entity:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end
end


function ENT:Use(activator,caller)
	local amount = self:GetAmount()

	activator:AddMoney(self:GetAmount() or 0)
	activator:ESSendNotification("generic","You picked up $ "..self:GetAmount()..",-","generic");
	self:Remove()
end

function ENT:Touch(ent)
	if not IsValid(self) or not IsValid(ent) or ent:GetClass() != "excl_cash" or ent.hasMerged or self.hasMerged then return end

	if self:GetAmount() >= ent:GetAmount() then
		ent.hasMerged = true;

		self:SetAmount(self:GetAmount() + ent:GetAmount());

		ent:Remove()
	end
end

function ERP:SpawnCash(amt,pos,ang)
	local e = ents.Create("excl_cash");
	e:SetPos(pos);
	e:SetAngles(ang);
	e:Spawn();
	e:SetAmount(tonumber(amt));
end