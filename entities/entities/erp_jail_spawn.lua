AddCSLuaFile();

ENT.Base = "base_anim"
ENT.PrintName	= "Jail Spawn"
ENT.Information	= "Jailed people will spawn here"
ENT.Category = "ExclRP"
ENT.Author = "Excl"
ENT.Spawnable			= true
ENT.AdminOnly			= true

if CLIENT then
  function ENT:Draw()
    self:DrawModel()
  end

  function ENT:Initialize()
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
  end
elseif SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_c17/clock01.mdl");

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)

    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end
end
