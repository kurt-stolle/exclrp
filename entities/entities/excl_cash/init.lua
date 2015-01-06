AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.Entity:SetModel("models/props/cs_assault/money.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self.Entity:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end
end


function ENT:Use(activator,caller)
	local amount = self.dt.amount

	activator:AddMoney(self.dt.amount or 0)
	activator:SendNotification("You picked up $ "..self.dt.amount..",-","generic");
	self:Remove()
end

function ENT:Touch(ent)
	if ent:GetClass() != "excl_cash" or ent.hasMerged or self.hasMerged then return end

	ent.hasMerged, self.hasMerged = true, true
	self:Remove()
	ent:Remove()

	GAMEMODE:SpawnCash(self.dt.amount + ent.dt.amount,self:GetPos(),self:GetAngles());
end

function GAMEMODE:SpawnCash(amt,pos,ang)
	local e = ents.Create("excl_cash");
	e:SetPos(pos);
	e:SetAngles(ang);
	e:Spawn();
	e:SetDTInt("amount",tonumber(amt));
end