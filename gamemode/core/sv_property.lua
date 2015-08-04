local doors = {
	"prop_door_rotating",
	"func_door",
	"func_door_rotating"
};
local PROPERTY=FindMetaTable("Property");

-- Console commands
local function cmdLock(ply,cmd,args)
	if not IsValid(ply) or not ply:IsLoaded() or not args[1] or not args[2] then return ply:CreateErrorDialog("Invalid arguments passed to (un)lock command.") end

	local ent=Entity(args[1])
	local prop=ERP.Properties[args[2]]

	if not IsValid(ent) or not prop or not table.HasValue(prop.doors,ent:EntIndex()) then return ply:CreateErrorDialog("Invalid property.") end

	if ent:GetPos():Distance(ply:GetPos()) > 200 then return ply:CreateErrorDialog("You are too far away from the entity to perform this action.") end

	if not prop:PlayerHasPermissions(ply) then return ply:CreateErrorDialog("You do not have permission to do this.") end

	ent:Fire(cmd == "erp_property_door_lock" and "Lock" or "UnLock",1)
	ent:EmitSound("doors/door_latch3.wav",100,cmd == "erp_property_door_lock" and 80 or 110)
end
concommand.Add("erp_property_door_lock",cmdLock);
concommand.Add("erp_property_door_unlock",cmdLock)

concommand.Add("erp_property_door_knock",function(ply,cmd,args)
	if not IsValid(ply) or not ply:IsLoaded() or not args[1] or not args[2] then return ply:CreateErrorDialog("Invalid arguments passed to knock command.") end

	local ent=Entity(args[1])
	local prop=ERP.Properties[args[2]]

	if not IsValid(ent) or not prop or not table.HasValue(prop.doors,ent:EntIndex()) then return ply:CreateErrorDialog("Invalid property.") end

	if ent:GetPos():Distance(ply:GetPos()) > 200 then return ply:CreateErrorDialog("You are too far away from the entity to perform this action.") end

	for i=0,.26*2,.26 do
		timer.Simple(i,function()
			if IsValid(ent) then
				ent:EmitSound("physics/wood/wood_crate_impact_hard2.wav",100,math.random(85,95))
			end
		end)
	end
end)

-- Database fetch
hook.Add("ESDatabaseReady","ERP.ES.SetupPropertySQL",function()
	ES.DebugPrint("Loading property information...")
	ES.DBQuery("CREATE TABLE IF NOT EXISTS `erp_property` (`id` int unsigned NOT NULL AUTO_INCREMENT, map varchar(255), name varchar(20), description varchar(255), factions int(8) unsigned, doors TEXT, owner INT unsigned, members varchar(255), owner_name varchar(255), expire_unix varchar(255), jobs TEXT, PRIMARY KEY (`id`), UNIQUE KEY (`id`)) ENGINE=MyISAM DEFAULT CHARSET=latin1;",function()
		ES.DBQuery("SELECT name,description,doors,factions,owner,members,expire_unix,owner_name FROM erp_property WHERE map='"..ES.DBEscape(game.GetMap()).."';",function(c)
			if c and c[1] then
				for k,v in ipairs(c)do
					ES.DebugPrint("Initializing property ",v.name)
					local prop=ERP.Property(v.name,v.description)

					-- Set the doors
					prop.doors = ES.Deserialize(v.doors or "");
					for index,door in ipairs(prop.doors)do
						prop.doors[index] = ( door + game.MaxPlayers() );
					end

					-- Figure out what type of property we're dealing with
					if v.jobs then
						ES.DebugPrint("Property is SHARED")
						prop.jobs = ES.Deserialize(v.jobs or "");
						prop:SetType(PROPERTY_SHARED)
					else
						ES.DebugPrint("Property is PRIVATE")
						if v.owner and tonumber(v.expire_unix) > os.time() then
							ES.DebugPrint("Property has an owner")
							prop.owner = v.owner
							prop:SetType(PROPERTY_PRIVATE)
							prop.ownerName = v.owner_name or "John Doe"
							prop.members = ES.Deserialize(v.members or "");
							prop.timeExpire=tonumber(v.expire_unix)
						end
					end

					-- Register the property
					prop()

					ES.DebugPrint("Successfully loaded property.")
				end
			end
		end);
	end);
end)

-- Check expirations
timer.Create("ERP.Property.ExpirationGuard",60,0,function()
	for k,v in ipairs(ERP.Properties)do
		if v:GetType() == PROPERTY_PRIVATE and v:HasOwner() and v:GetTimeExpire() <= os.time() then
			-- Check if the player is online
			local ply=ERP.FindPlayerByCharacterID(v:GetOwner());
			if IsValid(ply) then
				local price=self:GetPrice(1)

				if ply:GetCharacter():GetBank() > price then
					ply:GetCharacter():TakeBank(price)
					ply:ESSendNotification("generic","Your property "..v:GetName().." was extended by 1 hour")
					self:SetOwner(ply,1)

					return
				else
					ply:ESSendNotification("generic","Your property "..v:GetName().." has expired.")
				end
			end

			-- Expire the property
			self.owner = nil
			self.ownerName = nil
			self.members = nil
			self.timeExpire = nil

			-- update database
			ES.DBQuery("UPDATE erp_property SET owner = NULL, owner_name = NULL, members = NULL, expire_unix = 0 WHERE name = '"..tostring(self:GetName()).."' AND map='"..ES.DBEscape(game.GetMap()).."';");

			-- sync
			self:Sync()
		end
	end
end)

-- Fnctions
function ERP.DefineProperty(name,description,factions)
	ES.DBQuery(Format("INSERT INTO `erp_property` (map,name,description,factions) VALUES('%s','%s','%s',%s);", game.GetMap(),tostring(name),tostring(description),factions or 0));

	local prop=ERP.Property(name,description)
	prop:SetFactions(factions)
	prop()

	net.Start("ERP.property.addproperty")
		net.WriteString(name)
		net.WriteString(description)
		net.WriteUInt(factions,8)
	net.Broadcast()

	ES.DebugPrint("New property added!",name)
end

-- Meta object
function PROPERTY:AddDoor(e)
	if not self.doors then self.doors = {} end

	table.insert(self.doors,e:EntIndex());

	local doorsSave={}
	for k,v in ipairs(self.doors)do
		table.insert(doorsSave,v-game.MaxPlayers())
	end
	ES.DBQuery(Format("UPDATE erp_property SET doors = '%s' WHERE name = '%s' AND map='"..ES.DBEscape(game.GetMap()).."';", ES.Serialize(doorsSave),tostring(self:GetName())));

	net.Start("ERP.property.adddoor")
	net.WriteString(self:GetName())
	net.WriteUInt(e:EntIndex(),16)
	net.Broadcast()

	ES.DebugPrint("Door added to property",self:GetName())
end
function PROPERTY:AddJob(job)
	if not self.jobs then self.jobs = {} end

	table.insert(self.jobs,job);

	ES.DBQuery(Format("UPDATE erp_property SET jobs = '%s' WHERE name = '%s' AND map='"..ES.DBEscape(game.GetMap()).."';", ES.Serialize(self.jobs),tostring(self:GetName())));

	self:SetType(PROPERTY_SHARED)

	net.Start("ERP.property.addjob")
	net.WriteString(self:GetName())
	net.WriteString(job)
	net.Broadcast()

	ES.DebugPrint("Job added to property",self:GetName()," ",job)
end
function PROPERTY:SetOwner(ply,timeHours)
	if not ply:IsLoaded() then return end

	local char=ply:GetCharacter()

	self:SetTimeExpire(os.time() + timeHours*(60*60))

	if self:GetOwner() and self:GetOwner() == ply:GetCharacter():GetID() then
		ES.DBQuery(Format("UPDATE erp_property SET expire_unix = '%s' WHERE name = '"..tostring(self:GetName()).."' AND map='"..ES.DBEscape(game.GetMap()).."';",self:GetTimeExpire()));
	else
		self.members={char:GetID()}
		self.owner=char:GetID()
		self.ownerName=string.sub(char:GetFirstName(),1,1)..". "..char:GetLastName()

		ES.DBQuery(Format("UPDATE erp_property SET expire_unix = '%s', owner = %s, owner_name = '%s', members = '%s' WHERE name = '"..tostring(self:GetName()).."' AND map='"..ES.DBEscape(game.GetMap()).."';",self:GetTimeExpire(),self:GetOwner(),self:GetOwnerName(),ES.Serialize(self:GetMembers())));
	end

	self:Sync()
end
function PROPERTY:Sync(ply)
	net.Start("ERP.property.update")
	net.WriteTable(self)
	if IsValid(ply) then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

-- Networking
util.AddNetworkString("ERP.property.update")
util.AddNetworkString("ERP.property.sync");
hook.Add("ESPlayerReady","ERP.PlayerReady.SyncProperty",function(pl)
	ES.DebugPrint("Networking properties.")

	net.Start("ERP.property.sync");
	net.WriteTable(ERP.Properties);
	net.Send(pl);
end)
util.AddNetworkString("ERP.property.addproperty")
net.Receive("ERP.property.addproperty",function(len,pl)
	local name = net.ReadString()
	local description = net.ReadString()
	local factions = net.ReadUInt(8)

	if not pl:IsSuperAdmin() then return end

	local property = false;
	for k,v in pairs(ERP.Properties)do
		if v.name == name then
			property = v;
			break;
		end
	end
	if property then return end

	ERP.DefineProperty(name,description,factions);
end)
util.AddNetworkString("ERP.property.addjob")
net.Receive("ERP.property.addjob",function(len,pl)
	local property=net.ReadString()
	local job=net.ReadString()

	if not pl:IsSuperAdmin() then return end

	if not ERP.Jobs[job] then
		ES.DebugPrint("Job not found. ",job)
		return
	end

	if not ERP.Properties[property] then
		ES.DebugPrint("Property not found. ",property)
		return
	end

	ERP.Properties[property]:AddJob(job)
end)
util.AddNetworkString("ERP.property.adddoor")
net.Receive("ERP.property.adddoor",function(len,pl)
	local property=net.ReadString()
	local ent=Entity(net.ReadUInt(16))

	if not pl:IsSuperAdmin() then return end

	for k,v in ipairs(ERP.Properties)do
		for _,door in ipairs(v.doors or {})do
			if door == ent:EntIndex() then
				ES.DebugPrint("Failed to add door; Door already linked.")
				return;
			end
		end
	end

	for k,v in ipairs(ERP.Properties)do
		if v.IsProperty and v:GetName() == property then
			v:AddDoor(ent);
			return;
		end
	end

	ES.DebugPrint("Property not found :(")
end)
