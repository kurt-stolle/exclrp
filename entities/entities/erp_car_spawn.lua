AddCSLuaFile();

ENT.Base = "base_anim"
ENT.PrintName	= "Car Spawn"
ENT.Information	= "Cars will spawn here"
ENT.Category = "ExclRP"
ENT.Author = "Excl"
ENT.Spawnable			= true
ENT.AdminOnly			= true

if CLIENT then
  local mdl=ClientsideModel("models/buggy.mdl",RENDERGROUP_BOTH)
  function ENT:Draw()
    render.SetBlend(.5)
      mdl:SetRenderOrigin(self:GetPos())
      mdl:SetRenderAngles(self:GetAngles())
      mdl:DrawModel()
      mdl:SetRenderOrigin()
      mdl:SetRenderAngles()
    render.SetBlend(1)

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
