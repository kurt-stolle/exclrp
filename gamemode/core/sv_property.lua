local doors = {
	"prop_door_rotating",
	"func_door",
	"func_door_rotating"
};
local PROPERTY=FindMetaTable("Property");

hook.Add("ESDatabaseReady","ERP.ES.SetupPropertySQL",function()
	ES.DebugPrint("Loading property information...")
	ES.DBQuery("CREATE TABLE IF NOT EXISTS `erp_property` (`id` int unsigned NOT NULL AUTO_INCREMENT, map varchar(255), name varchar(20), description varchar(255), factions int(8) unsigned, doors TEXT, owner INT unsigned, members varchar(255), expire_unix varchar(255), jobs TEXT, PRIMARY KEY (`id`), UNIQUE KEY (`id`)) ENGINE=MyISAM DEFAULT CHARSET=latin1;",function()
		ES.DBQuery("SELECT name,description,doors,factions,owner,members,expire_unix FROM erp_property WHERE map='"..ES.DBEscape(game.GetMap()).."';",function(c)
			if c and c[1] then
				for k,v in ipairs(c)do
					v.doors = ES.Deserialize(v.doors or "");
					for index,door in ipairs(v.doors)do
						v.doors[index] = ( door + game.MaxPlayers() );
					end
					v.members = ES.Deserialize(v.members or "");
					v.jobs = ES.Deserialize(v.jobs or "");

					setmetatable(v,PROPERTY)
					PROPERTY.__index = PROPERTY;

					ES.DebugPrint("Property loaded: ",v.name)
				end
				ERP.Properties = c;
			end
		end):wait();
	end):wait();
end)

-- Fnctions
function ERP.Property(name,description,factions)
	ES.DBQuery(Format("INSERT INTO `erp_property` (map,name,description,factions) VALUES('%s','%s','%s',%s);", game.GetMap(),tostring(name),tostring(description),factions or 0));

	local tab={
		name=name,
		description=description,
		factions=factions,
		members={},
		doors={},
		jobs={}
	};
	setmetatable(tab,PROPERTY)
	PROPERTY.__index = PROPERTY;

	table.insert(ERP.Properties,tab)

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

	net.Start("ERP.property.addjob")
	net.WriteString(self:GetName())
	net.WriteString(job)
	net.Broadcast()

	ES.DebugPrint("Job added to property",self:GetName()," ",job)
end
function PROPERTY:SetOwner(ply,timeHours)

end

-- Networking
util.AddNetworkString( "ERP.property.sync" );
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

	ERP.Property(name,description,factions);
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
