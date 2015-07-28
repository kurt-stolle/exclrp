AddCSLuaFile()

DEFINE_BASECLASS("erp_weapon_base_firearm")

SWEP.Base = "erp_weapon_base_firearm"

-- Display values
SWEP.PrintName = "SPAS-12"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "ExclRP"
SWEP.UseHands = true
SWEP.Slot = 2
SWEP.GenerateItem = true

-- Configuration values
SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.HoldType = "smg"
SWEP.CanRechamber = false
SWEP.Sound = "Weapon_Shotgun"

SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Buckshot Ammo"
SWEP.Primary.Recoil = 5
SWEP.Primary.Accuracy = 0.1
SWEP.Primary.Force = 10
SWEP.Primary.Delay = 0.25
SWEP.Primary.Damage = 10
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 10
