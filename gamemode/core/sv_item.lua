local ITEM=FindMetaTable("Item");

function ITEM:SpawnInWorld(pos,ang,data)

	local e = ents.Create("erp_object_"..util.CRC(self._name));
	e:SetPos(pos);
	e:SetAngles(ang);
	e.Item = self
	e:Spawn();
	e:Activate();

	if data then
		for k,v in pairs(data)do
			if e["Set"..k] then
				e["Set"..k](e,v)
			end
		end
	end

	return e;
end

concommand.Add("erp_admin_spawnitem",function(p,c,a)
	if not IsValid(p) or not p:IsSuperAdmin() then
		p:ChatPrint("This command is for Super Administrators only.");
		return
	end

	local name = table.concat(a," ");
	if ERP.Items[name] then
		ERP.Items[name]:SpawnInWorld(p:GetEyeTrace().HitPos,p:GetAngles());
	else
		ES.DebugPrint("UNKNOWN ITEM: "..name);
	end
end)

util.AddNetworkString("ERP.InteractItem")
net.Receive("ERP.InteractItem",function(len,ply)
		if not IsValid(ply) then return end

		local ent=net.ReadEntity()
		local interaction=net.ReadString()

	  if not ent.GetItem or not ent:GetItem() or not ent:GetItem()._interactions[interaction] then
			ES.DebugPrint("Invalid interaction requested: ",interaction);
			return
		end

		ent:GetItem()._interactions[interaction](ent,ply);
end)

util.AddNetworkString("ERP.PickupItem")
net.Receive("ERP.PickupItem",function(len,ply)
	if not IsValid(ply) then return end

	local ent = net.ReadEntity()

	if not IsValid(ent) or ent:GetPos():Distance(ply:EyePos()) > 200 or ent:IsPlayerHolding() then return end

	 ply:PickupObject( ent )
end)

util.AddNetworkString("ERP.ItemToInventory")
net.Receive("ERP.ItemToInventory",function(len,ply)
	if not IsValid(ply) then return end

	local ent = net.ReadEntity()

	if not IsValid(ent) or ent:GetPos():Distance(ply:EyePos()) > 200 then return end

	local char = ply:GetCharacter();
	local item = ent:GetItem()

	if not char or not ERP.ValidItem(item) then return end

	if tobool(char:GetInventory():FitItem(item)) then
		local data={}
		for k,v in pairs(item._data)do
			data[k]=ent["Get"..k](ent)
		end

		char:GiveItem(item,nil,nil,data)
		ent:Remove();
	end
end)
