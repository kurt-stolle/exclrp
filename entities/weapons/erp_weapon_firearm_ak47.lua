AddCSLuaFile()

DEFINE_BASECLASS("erp_weapon_base_firearm")

SWEP.Base = "erp_weapon_base_firearm"

-- Display vallues
SWEP.PrintName = "AK-47"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "ExclRP"
SWEP.UseHands = true
SWEP.Slot = 2
SWEP.GenerateItem = true

-- Configuration values
SWEP.ViewModel = "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.HoldType = "smg"
SWEP.CanRechamber = false
SWEP.Sound = "Weapon_AK47"

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Rifle Ammo"
SWEP.Primary.Recoil = 3
SWEP.Primary.Accuracy = 0.03
SWEP.Primary.Force = 20
SWEP.Primary.Delay = .1
SWEP.Primary.Damage = 36
SWEP.Primary.Automatic = true
SWEP.Primary.NumShots = 1
