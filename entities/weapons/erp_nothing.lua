
AddCSLuaFile()

SWEP.PrintName		= "Fists";

SWEP.UseHands = true;

SWEP.Author			= "Excl"
SWEP.Purpose		= ""

SWEP.ViewModel	= ""
SWEP.WorldModel	= ""

SWEP.ViewModelFOV	= 52
SWEP.Slot			= 0
SWEP.SlotPos		= 5

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
  self:SetHoldType( "normal" )
end
function SWEP:Reload()
end

function SWEP:SecondaryAttack()
end

function SWEP:Holster( wep )
	return true
end

function SWEP:Deploy()
	return true
end
