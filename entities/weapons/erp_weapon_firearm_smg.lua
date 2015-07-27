AddCSLuaFile()

DEFINE_BASECLASS("erp_weapon_base_firearm")

SWEP.Base = "erp_weapon_base_firearm"

-- Display vallues
SWEP.PrintName = "HK MP7"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "ExclRP"
SWEP.UseHands = true
SWEP.Slot = 2
SWEP.GenerateItem = true

-- Configuration values
SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.HoldType = "smg"
SWEP.CanRechamber = false
SWEP.Sound = "Weapon_SMG1"

SWEP.Primary.ClipSize = 45
SWEP.Primary.DefaultClip = 45
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SMG Ammo"
SWEP.Primary.Recoil = 1
SWEP.Primary.Accuracy = 0.04
SWEP.Primary.Force = 20
SWEP.Primary.Delay = .09
SWEP.Primary.Damage = 4
SWEP.Primary.Automatic = true
