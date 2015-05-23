local ITEM=FindMetaTable("Item");

function ITEM:SpawnInWorld(pos,ang)

	local e = ents.Create("excl_object_"..util.CRC(self._name));
	e:SetPos(pos);
	e:SetAngles(ang);
	e:Spawn();
	e:Activate();

	return e;
end

concommand.Add("excl_admin_spawnitem",function(p,c,a)
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

	  if not ent:GetItem() or not ent:GetItem()._interactions[interaction] then return end

		ent:GetItem()._interactions[interaction](ply);
end)
