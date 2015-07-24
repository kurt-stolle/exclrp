AddCSLuaFile()

local ply;

WEAPON_STATUS_NONE = 0
WEAPON_STATUS_AIM = 1
WEAPON_STATUS_RUN = 2

SWEP.Base = "erp_weapon_base"
SWEP.PrintName = "Firearm Base"
SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.Spawnable = false
SWEP.AdminOnly = true
SWEP.UseHands = true
SWEP.Category = "ExclRP"

SWEP.HoldType = "pistol"

SWEP.BaseAccurary = 0.5

SWEP.Primary.ClipSize = 16
SWEP.Primary.DefaultClip = 16
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:SetupDataTables()
  self:NetworkVar("Int",0,"Status")
end

function SWEP:Initialize()
  self:SetHoldType( self.HoldType )
end

function SWEP:IsFirearm()
  return true
end

function SWEP:IsSidearm()
  return self.HoldType == "pistol"
end

function SWEP:Reload()
  -- Implement me
end

function SWEP:PrimaryAttack()
  -- Implement me
end

function SWEP:Think()
  ply=self.Owner;

  if not IsValid(ply) then return end

  -- Check if running
  if ply:KeyDown(IN_SPEED) and ply:GetVelocity():Length() > ply:GetRunSpeed() + 10 and ply:IsOnGround() then
    if self:GetStatus() ~= WEAPON_STATUS_RUN then
      self:SetStatus(WEAPON_STATUS_RUN)
    end

  -- Check if aiming
  elseif ply:KeyDown(IN_ATTACK2) then
    if self:GetStatus() ~= WEAPON_STATUS_AIM then
      self:SetStatus(WEAPON_STATUS_AIM)
    end

  -- Check if just chilling
  else
    if self:GetStatus() ~= WEAPON_STATUS_NONE then
      self:SetStatus(WEAPON_STATUS_NONE)
    end

  end

  -- Close the gap if last fire > x seconds
  if self.lastFire + 1 < CurTime() then
    self.accuracy = Lerp(FrameTime(),self.accuracy,self.BaseAccurary)
  end
end
