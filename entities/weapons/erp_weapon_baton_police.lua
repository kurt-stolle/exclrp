AddCSLuaFile()

SWEP.Base = "erp_weapon_base_baton"

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

    if job:GetFaction() ~= FACTION_GOVERNMENT then
      if CLIENT then
        ES.Notify("generic","Only Government may arrest other people.")
      end
      self:PrimaryAttack()
      return
    end

    self:Swing(function(ent)
      if CLIENT then return end

      if IsValid(ent) and ent:IsPlayer() and ent:IsLoaded() then
        local job=ERP.Jobs[ent:Team()];

        if job and job:GetFaction() == FACTION_GOVERNMENT then return self.Owner:ESSendNotification("You can not arrest another Government employee!") end

        ent:GetCharacter():Arrest()
      end
    end)
  end
end
