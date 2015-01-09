ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "exclObject"
ENT.Author = "_NewBee (Excl)"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Entity",0,"Owner")
	self:NetworkVar("Int",0,"ItemID");
end

function ENT:GetItem()
	return ERP.Items[self:GetItemID()];
end

function ENT:SetItem(item)
	self:SetItemID(item:GetID());
end

function ENT:Think()
	if not self._bItemLoaded then
		if self:GetItem() then
			for k,v in pairs(self:GetItem().hooks)do
				if k == "Initialize" then
					v(self);
					return;
				end
				self[k] = v;
			end
			self._bItemLoaded=true;
		end
	end
end