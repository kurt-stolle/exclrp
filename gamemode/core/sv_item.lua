local ITEM=FindMetaTable("Item");

function ITEM:SpawnInWorld(pos,ang,owner)

	local e = ents.Create("excl_object");
	e:SetPos(pos);
	e:SetAngles(ang);
	e:SetModel(self._model);

	if IsValid(owner) then
		e:SetOwner(owner);
	end

	for k,v in pairs(self._hooks)do
		if k ~= "Drop" and k ~= "Initialize" and k ~= "SetupDataTables" then -- Drop can only be called from the inventory. Defined what happens when the item is dropped/spawned.
			e[k]=v;
		end
	end

	e:Spawn();
	e:SetItem(self);
end

concommand.Add("excl_admin_spawnitem",function(p,c,a)
	if not IsValid(p) or not p:IsSuperAdmin() then 
		p:ChatPrint("This command is for Super Administrators only.");
		return
	end

	local name = table.concat(a," ");
	if ERP.Items[name] then
		ERP.Items[name]:SpawnInWorld(p:GetEyeTrace().HitPos,p:GetAngles(),p);
	else
		ES.DebugPrint("UNKNOWN ITEM: "..name);
	end
end)