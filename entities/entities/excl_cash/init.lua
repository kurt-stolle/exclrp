AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props/cs_assault/money.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetAmount(1);

	local phys = self.Entity:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end

	self:DropToFloor()
end


function ENT:Use(activator,caller)
	if not activator.character then return end

	local amount = self:GetAmount()

	activator.character:AddCash(self:GetAmount() or 0)
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
