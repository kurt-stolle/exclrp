ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cash"
ENT.Author = "_NewBee (Excl)"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:DTVar("Int",0,"amount")
end
local emeta = FindMetaTable("Entity");
function emeta:IsCash()
	return e:GetClass()=="excl_cash";
end