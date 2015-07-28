AddCSLuaFile()

if SERVER then
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true
	SWEP.AccurateCrosshair = false
	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
end

SWEP.Base = "weapon_base"
SWEP.PrintName = "Weapon Base"
SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.GenerateItem = false

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

if SERVER then return end

SWEP.CrosshairGap = 20

local size = 12
function SWEP:DoDrawCrosshair( x, y )
	-- Hack x and y to the actual values we're interested in
	local pos=LocalPlayer():GetEyeTrace().HitPos:ToScreen()
	x,y=pos.x,pos.y

	-- Draw the crosshair
	surface.SetDrawColor( ES.Color["#FFFFFFEE"] )

	surface.DrawRect( x - self.CrosshairGap/2 - size	, y-1, size, 2 )
	surface.DrawRect( x + self.CrosshairGap/2					, y-1, size, 2 )

	surface.DrawRect( x-1, y - self.CrosshairGap/2 - size	, 2, size)
	surface.DrawRect( x-1, y + self.CrosshairGap/2				, 2, size)
	-- Supress the default
	return true
end
