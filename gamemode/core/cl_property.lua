local DoorTypes = {
	"prop_door_rotating",
	"func_door",
	"func_door_rotating"
};
local Doors = {}
local PROPERTY = FindMetaTable("Property")

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

	local factions=0;
	if a[1] == "all" then
		factions=bit.bor( FACTION_CIVILLIAN,FACTION_GOVERNMENT,FACTION_CRIME )
	else
		for k,v in ipairs(a)do
			if string.lower(v)=="civillian" then
				factions=bit.bor(factions,FACTION_CIVILLIAN)
			elseif string.lower(v)=="government" then
				factions=bit.bor(factions,FACTION_GOVERNMENT)
			elseif string.lower(v)=="crime" then
				factions=bit.bor(factions,FACTION_CRIME)
			end
		end
	end

	net.Start("ERP.property.addproperty")
	net.WriteString(name)
	net.WriteString(description)
	net.WriteUInt(factions,8)
	net.SendToServer()

	print("Property added.")
end,function(_,str)
	return {"undefined"}
end,"Create a new property. Format: <Property Name> <Description> <Factions: all OR crime OR government OR civillian>")

concommand.Add("excl_admin_property_add_door",function(_,_,a)
	if not LocalPlayer():IsSuperAdmin() then print("You need at least Super Admin to run this command.") return end

	local property = a[1];

	if not property or not ERP.Properties[property] then print("Invalid arguments: "..tostring(property)) return end

	local ent=LocalPlayer():GetEyeTrace().Entity

	if not IsValid(ent) then print("No door found.") return end

	ent=ent:EntIndex();

	if Doors[ent] then print("Door already has a proprty.") return end

	net.Start("ERP.property.adddoor")
	net.WriteString(property)
	net.WriteUInt(ent,16)
	net.SendToServer()

	print("Door added to property "..property..".")
end,function(_,str)
	return {"undefined"}
end,"Add the door you're facing to a property. Format: <Property name>")

concommand.Add("excl_admin_property_list",function(_,_,a)
	print("-- START PROPERTY LIST --")
	for k,v in pairs(ERP.Properties)do
		print(v.name.." \t["..v.description.."] ["..math.IntToBin(v.factions).."]\n")
	end
	print("--  END PROPERTY LIST --")
end,function(_,str)
	return {"undefined"}
end,"Add the door you're facing to a property. Format: <Property name>")

-- Networking
net.Receive("ERP.property.sync",function(len)
	ES.DebugPrint("Properties loaded!")

	while(#ERP.Properties > 0)do
		table.remove(ERP.Properties,#ERP.Properties);
	end
	for k,v in ipairs(net.ReadTable())do
		ERP.Properties[k]=v;
		setmetatable(v,PROPERTY)
		PROPERTY.__index = PROPERTY
	end

	for k,v in pairs(ERP.Properties)do
		for _,door in ipairs(v.doors)do
			Doors[door]=v;
		end
	end
end)
net.Receive("ERP.property.adddoor",function(len)
	local property=ERP.Properties[net.ReadString()]

	if not property then return end

	local index=net.ReadUInt(16);
	Doors[index]=property;

	if not property.doors then
		property.doors = {}
	end

	table.insert(property.doors,index)

	ES.DebugPrint("Doors updated!")
end)
net.Receive("ERP.property.addproperty",function(len)
	local tab={
		name=net.ReadString(),
		description=net.ReadString(),
		factions=net.ReadUInt(8)
	}
	setmetatable(tab,PROPERTY)
	PROPERTY.__index = PROPERTY
	table.insert(ERP.Properties,tab)

	ES.DebugPrint("Properties updated!")
end)

-- HUD
local alpha = 0
hook.Add("HUDPaint","exclDoorPropertyHints",function()
	local lp = LocalPlayer();
	local door = lp:GetEyeTrace().Entity;

	if IsValid(door) and table.HasValue(DoorTypes,door:GetClass()) and Doors[door:EntIndex()] then
		local pos = door:LocalToWorld(door:OBBCenter());

		if pos:Distance(lp:EyePos()) < 150 then
			pos=pos:ToScreen();

			local pr=Doors[door:EntIndex()];

			local x,y=pos.x,pos.y - 16

			local propertyName=pr:GetName() or "Undefined"
			draw.SimpleText(propertyName,"ESDefault+.Shadow",x,y,ES.Color.Black,1,1)
			draw.SimpleText(propertyName,"ESDefault+.Shadow",x,y+1,ES.Color.Black,1,1)
			local _,yAdd = draw.SimpleText(propertyName,"ESDefault+",x,y,ES.Color.White,1,1)

			y=y+yAdd+4;

			local ownerString=pr:HasOwner() and "Undefined" or "FOR RENT ($"..pr:GetPrice(1).." per hour)";
			draw.SimpleText(ownerString,"ESDefault.Shadow",x,y,ES.Color.Black,1,1)
			draw.SimpleText(ownerString,"ESDefault.Shadow",x,y+1,ES.Color.Black,1,1)
			draw.SimpleText(ownerString,"ESDefault",x,y,ES.Color.White,1,1)
		end
	end
end);
