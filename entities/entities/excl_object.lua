AddCSLuaFile();

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "EXCLRP ITEM"
ENT.Author = "Excl"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"ItemKey");
end

function ENT:Initialize()	
	self._bItemLoaded=SERVER;

	self:SetModel(self:GetItem()._model);
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject();
	if phys and phys:IsValid() then 
		phys:Wake();
	end
end

function ENT:GetItem()
	return ERP.Items[self:GetItemKey()];
end

function ENT:SetItem(item)
	self:SetItemKey(item:GetKey());
end

if CLIENT then
	function ENT:Think()
		if not self._bItemLoaded then
			if self:GetItem() then
				for k,v in pairs(self:GetItem()._hooks)do
					if k == "Initialize" then
						v(self);
						return;
					elseif k == "Think" then
						self.Think = v;
					end
					self[k] = v;
				end
				self._bItemLoaded=true;

				ES.DebugPrint("Object item tables set: "..(self:GetItem():GetName() or "ERROR"));
			end
		end
	end
end