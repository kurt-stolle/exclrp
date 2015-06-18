AddCSLuaFile()

if SERVER then
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.AccurateCrosshair = true
	SWEP.ViewModelFOV		= 82
	SWEP.ViewModelFlip		= false
end

SWEP.Base = "weapon_base"
SWEP.PrintName = "Weapon Base"
SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.Author = "Excl"
SWEP.Contact = "info@casualbananas.com"
SWEP.Purpose = "Undefined"
SWEP.Instructions = "Undefined"

SWEP.Spawnable = false
SWEP.AdminOnly = true
SWEP.UseHands = true
SWEP.Category = "ExclRP"

SWEP.HoldType = "normal"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:SetupDataTables()

end

function SWEP:Initialize()
  self:SetHoldType( self.HoldType )
end
function SWEP:Reload()
  -- Implement me
end

function SWEP:PrimaryAttack()
  -- Implement me
end
function SWEP:SecondaryAttack()
  -- Implement me
end

function SWEP:Holster( wep )
  -- Implement me

	return true
end

function SWEP:Deploy()
  -- Implement me

	return true
end
