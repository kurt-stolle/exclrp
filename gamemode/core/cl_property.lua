local doors = {
	"prop_door_rotating",
	"func_door",
	"func_door_rotating"
};

hook.Add("OnContextMenuOpen","ERP.ContextMenu.Properties",function()
	local e = LocalPlayer():GetEyeTrace().Entity;

	if IsValid(e) and LocalPlayer():IsLoaded() and LocalPlayer():GetEyeTrace().HitPos:Distance(LocalPlayer():EyePos()) < 100 then

		if table.HasValue(doors,e:GetClass()) and availableProperty[e:EntIndex()] then
			if not ERP.OwnedProperty[availableProperty[e:EntIndex()]] then
				ERP:CreateActionMenu(LocalPlayer():GetEyeTrace().HitPos,{
					{text="Buy property",func=function()
						RunConsoleCommand("excl_buyproperty");
					end}
				})
			elseif ERP.OwnedProperty[availableProperty[e:EntIndex()]].id == LocalPlayer():UniqueID() then
				ERP:CreateActionMenu(LocalPlayer():GetEyeTrace().HitPos,{
					{text="Lock",func=function()
						RunConsoleCommand("excl_lockdoor");
					end},
					{text="Unlock",func=function()
						RunConsoleCommand("excl_unlockdoor");
					end}
				})
			else

			end
		end

	end
end)

-- Console commands
concommand.Add("excl_admin_property_create",function(_,_,a)
	if not LocalPlayer():IsSuperAdmin() then print("You need at least Super Admin to run this command.") return end

	local name = a[1];
	local description = a[2];

	if not name or not description then print("Invalid arguments.") return end

	table.remove(a,1)
	table.remove(a,1)

	local factions={};
	if a[1] == "all" then
		factions={FACTION_CIVILLIAN,FACTION_GOVERNMENT,FACTION_CRIME}
	else
		for k,v in ipairs(a)do
			if string.lower(v)=="civillian" then
				table.insert(factions,FACTION_CIVILLIAN)
			elseif string.lower(v)=="government" then
				table.insert(factions,FACTION_GOVERNMENT)
			elseif string.lower(v)=="crime" then
				table.insert(factions,FACTION_CRIME)
			end
		end
	end

	net.Start("ERP.property.addproperty")
	net.WriteString(name)
	net.WriteString(description)
	net.WriteTable(factions)
	net.Broadcast()

	print("Property added.")
end,function(_,str)
	return {"undefined"}
end,"Create a new property. Format: Name, Description, Factions")

concommand.Add("excl_admin_property_add_door",function(_,_,a)
	if not LocalPlayer():IsSuperAdmin() then print("You need at least Super Admin to run this command.") return end

	local property = a[1];

	if not property or not ERP.Properties[property] then print("Invalid arguments.") return end

	local ent=LocalPlayer():GetEyeTrace().Entity

	if not IsValid(ent) then return end

	net.Start("ERP.property.adddoor")
	net.WriteString(property)
	net.WriteUInt(ent:EntIndex(),16)
	net.Broadcast()

	print("Door added to property "..property..".")
end,function(_,str)
	return {"undefined"}
end,"Add the door you're facing to a property. Format: Property name")

-- Networking
net.Receive("ERP.property.sync",function(len)
	ERP.Properties = net.ReadTable();
end)
net.Receive("ERP.property.adddoor",function(len)
	local property=ERP.Properties[net.ReadString()]

	if not property then

	table.insert(property.doors,net.ReadUInt(16))
end)
net.Receive("ERP.property.addproperty",function(len)
	table.insert(ERP.Properties,{
		name=net.ReadString(),
		description=net.ReadString(),
		factions=net.ReadTable()
	})
end)

-- HUD
local alpha = 0
hook.Add("HUDPaint","exclDoorPropertyHints",function()
	local lp = LocalPlayer();
	if lp:GetEyeTrace() and IsValid(lp:GetEyeTrace().Entity) and table.HasValue(doors,lp:GetEyeTrace().Entity:GetClass()) and availableProperty[lp:GetEyeTrace().Entity:EntIndex()] then
		local e = lp:GetEyeTrace().Entity;
		local p = e:LocalToWorld(e:OBBCenter());

		if lp:GetEyeTrace().HitPos:Distance(lp:EyePos()) < 100 then
			alpha = Lerp(0.01,alpha,255);
		else
			alpha = Lerp(0.1,alpha,0);
		end

		p = p:ToScreen();

		draw.SimpleTextOutlined(ERP.Properties[availableProperty[e:EntIndex()]].name or "Error! Unidentified property!","ESDefault+",p.x,p.y,Color(255,255,255,alpha),1,1,1,Color(0,0,0,alpha));
		if ERP.OwnedProperty[availableProperty[e:EntIndex()]] then
			draw.SimpleTextOutlined("Owned by: "..ERP.OwnedProperty[availableProperty[e:EntIndex()]].nick,"ESDefaultBold",p.x,p.y+25,Color(255,255,255,alpha),1,1,1,Color(0,0,0,alpha));
		else
			draw.SimpleTextOutlined("Press C to rent","ESDefaultBold",p.x,p.y+25,Color(200,200,200,alpha),1,1,1,Color(0,0,0,alpha));
			draw.SimpleTextOutlined("This property costs $"..tostring(50+(#ERP.Properties[availableProperty[e:EntIndex()]].doors*6))..",- per hour.","ESDefaultBold",p.x,p.y+40,Color(200,200,200,alpha),1,1,1,Color(0,0,0,alpha));
		end
	else
		if alpha > .5 then
			alpha = Lerp(0.1,alpha,0);
		end
	end
end);
