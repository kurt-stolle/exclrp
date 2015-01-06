ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "exclObject"
ENT.Author = "_NewBee (Excl)"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:DTVar("Entity",0,"owner")
end