AddCSLuaFile();

ENT.Base = "base_anim"
ENT.PrintName	= "Item"
ENT.Information	= "An ExclRP item"
ENT.Category = "ExclRP"
ENT.Author = "Excl"
ENT.Spawnable			= false
ENT.AdminOnly			= true
ENT.Item = 0

function ENT:GetItem()
	return ERP.Items[self.Item];
end

if CLIENT then
	hook.Add("OnContextMenuOpen","ERP.ContextMenu.Objects",function()
		local ply=LocalPlayer()
		local e = ply:GetEyeTrace().Entity;

		if IsValid(e) and e.Item and ply:GetEyeTrace().HitPos:Distance(ply:EyePos()) < 100 then
			LocalPlayer():ConCommand("+use")
			timer.Simple(.1,function() LocalPlayer():ConCommand("-use") end)
			return true
		end
	end)

	net.Receive("ERP.Item.UseTransmit",function()
		local ent=net.ReadEntity()

		if not IsValid(ent) or not ent.GetItem then
			ES.DebugPrint("Item is not of proper class.")
			return
		end

		local opts={}
		opts[1] = {text="Pick up",func=function()
			net.Start("ERP.PickupItem")
			net.WriteEntity(ent)
			net.SendToServer()
		end}
		opts[2] = {text="To inventory",func=function()
			net.Start("ERP.ItemToInventory")
			net.WriteEntity(ent)
			net.SendToServer()
		end}
		for k,v in pairs(ent:GetItem()._interactions)do
			opts[#opts+1]={text=k,func=function()
				v(ent,LocalPlayer())
			end}
		end

		ERP:CreateActionMenu(ent:LocalToWorld(ent:OBBCenter()),opts)
	end)
elseif SERVER then
	function ENT:Initialize()
		self:SetModel(self:GetItem()._model);

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		self:SetUseType(SIMPLE_USE);

		local phys = self:GetPhysicsObject();
		if phys and phys:IsValid() then
			phys:Wake();
		end
	end

	util.AddNetworkString("ERP.Item.UseTransmit")

	function ENT:Use(p)
		if not (not IsValid(p) or not p.IsPlayer or not p:IsPlayer() or self:IsPlayerHolding()) then
			net.Start("ERP.Item.UseTransmit")
			net.WriteEntity(self)
			net.Send(p)
		end
	end
end
