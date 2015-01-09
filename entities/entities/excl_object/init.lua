AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")



function ENT:Initialize()	
	self._bItemLoaded=false;
	
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self.Entity:GetPhysicsObject();
	if phys and phys:IsValid() then 
		phys:Wake();
	end
end
