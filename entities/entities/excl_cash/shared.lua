ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cash"
ENT.Author = "_NewBee (Excl)"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"Amount")
end
local emeta = FindMetaTable("Entity");
function emeta:IsCash()
	return e:GetClass()=="excl_cash";
end