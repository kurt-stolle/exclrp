-- ExclRP Stove

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_interiors/stove02.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local physObj = self:GetPhysicsObject()
	physObj:Wake()
	physObj:SetMass(10)
	self.Damage = 100
	self.Sparking = false
end

function ENT:StartTouch(ent)
	if (ent:GetClass = "excl_object") then 
	end
end