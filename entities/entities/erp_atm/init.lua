AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.Entity:SetModel("models/props_unique/atm01.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self.Entity:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end
end

function ENT:Use(activator,caller)
	if IsValid(activator) and activator:IsPlayer() then
		umsg.Start("exclOpenATMMenu",activator); umsg.End();
	end
end
concommand.Add("erp_bank_deposit",function(p,c,a)
	if not a[1] or tonumber(a[1]) < 1 or not p:GetEyeTrace().Entity or p:GetEyeTrace().Entity:GetClass() != "erp_atm" or p:GetEyeTrace().Entity:GetPos():Distance(p:GetPos()+Vector(0,0,50)) > 120 or tonumber(a[1]) > p.character:GetCash() then return end

	p.character:AddBank(tonumber(a[1]));
	p.character:TakeCash(tonumber(a[1]));

	umsg.Start("eDeposDone",p); umsg.Long(tonumber(a[1])); umsg.End();
end)
concommand.Add("erp_bank_withdraw",function(p,c,a)
	if not a[1] or tonumber(a[1]) < 1 or not p:GetEyeTrace().Entity or p:GetEyeTrace().Entity:GetClass() != "erp_atm" or p:GetEyeTrace().Entity:GetPos():Distance(p:GetPos()+Vector(0,0,50)) > 120 or tonumber(a[1]) > p.character:GetBank() then return end

	p.character:TakeBank(tonumber(a[1]));
	p.character:AddCash(tonumber(a[1]));

	umsg.Start("eWithdrDone",p); umsg.Long(tonumber(a[1])); umsg.End();
end)
