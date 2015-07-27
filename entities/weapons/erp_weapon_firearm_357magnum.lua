AddCSLuaFile()

DEFINE_BASECLASS("erp_weapon_base_firearm")

SWEP.Base = "erp_weapon_base_firearm"

-- Display vallues
SWEP.PrintName = ".357 Magnum"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "ExclRP"
SWEP.UseHands = true
SWEP.Slot = 1
SWEP.GenerateItem = true

-- Configuration values
SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.HoldType = "pistol"
SWEP.CanRechamber = false
SWEP.Sound = "Weapon_357"

SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357 Ammo"
SWEP.Primary.Recoil = 1
SWEP.Primary.Accuracy = 0.01
SWEP.Primary.Force = 20
SWEP.Primary.Delay = .7
SWEP.Primary.Damage = 30
SWEP.Primary.Automatic = false
