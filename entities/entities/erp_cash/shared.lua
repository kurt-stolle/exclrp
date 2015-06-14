ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName	= "Cash"
ENT.Information	= "Cash money"
ENT.Category = "ExclRP"
ENT.Author = "Excl"
ENT.Spawnable = true
ENT.AdminOnly = true


function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"Amount")
end
local emeta = FindMetaTable("Entity");
function emeta:IsCash()
	return e:GetClass()=="erp_cash";
end
