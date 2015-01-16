ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Cash"
ENT.Author = "Excl"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"Amount")
end
local emeta = FindMetaTable("Entity");
function emeta:IsCash()
	return e:GetClass()=="excl_cash";
end