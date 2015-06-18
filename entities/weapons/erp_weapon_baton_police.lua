AddCSLuaFile()

SWEP.Base = "erp_weapon_baton"

SWEP.PrintName = "Police Baton"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "ExclRP"
SWEP.UseHands = true

SWEP.StickColor = ES.Color.Blue

function SWEP:SecondaryAttack()
  if IsValid(self.Owner) and self.Owner:IsLoaded() then
    local job=ERP.Jobs[self.Owner:Team()];

    if not job then return end

    if job:GetFaction() ~= FACTION_GOVERNMENT then return end

    self:Swing(function(ent)
      if IsValid(ent) and ent:IsPlayer() and ent:IsLoaded() then
        local job=ERP.Jobs[ent:Team()];

        if job and job:GetFaction() == FACTION_GOVERNMENT then return end

        ent:GetCharacter():Arrest()
      end
    end)
  end
end
