local ITEM=FindMetaTable("Item");

function ITEM:SpawnInWorld(pos,ang)

	local e = ents.Create("excl_object");
	e:SetPos(pos);
	e:SetAngles(ang);
	e:SetItem(self);

	for k,v in pairs(self._hooks)do
		if k ~= "Drop" and k ~= "Initialize" and k ~= "SetupDataTables" then -- Drop can only be called from the inventory. Defined what happens when the item is dropped/spawned.
			e[k]=v;
		end
	end

	e:Spawn();
	if self._hooks.Initialize then
		self._hooks.Initialize(e);
	end
	e:Activate();
	
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