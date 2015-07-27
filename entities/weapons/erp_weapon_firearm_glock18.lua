AddCSLuaFile()

DEFINE_BASECLASS("erp_weapon_base_firearm")

SWEP.Base = "erp_weapon_base_firearm"

-- Display values
SWEP.PrintName = "Glock 18"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "ExclRP"
SWEP.UseHands = true
SWEP.Slot = 1
SWEP.GenerateItem = true

-- Configuration values
SWEP.ViewModel = "models/weapons/cstrike/c_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"
SWEP.HoldType = "pistol"
SWEP.CanRechamber = false
SWEP.Sound = "Weapon_Glock"

SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Pistol Ammo"
SWEP.Primary.Recoil = 1
SWEP.Primary.Accuracy = 0.03
SWEP.Primary.Force = 10
SWEP.Primary.Delay = 0.1
SWEP.Primary.Damage = 28
SWEP.Primary.Automatic = false
