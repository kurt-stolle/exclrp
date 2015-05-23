local doors = {
	"prop_door_rotating",
	"func_door",
	"func_door_rotating"
};

hook.Add("ESDatabaseReady","ERP.ES.SetupPropertySQL",function()
	ES.DBQuery("CREATE TABLE IF NOT EXISTS `erp_property` (`id` SMALLINT(5) unsigned NOT NULL, map varchar(255), name varchar(20), description varchar(255), factions varchar(255), doors varchar(255), owner INT unsigned, admins varchar(255), members varchar(255), expire_unix varchar(255), PRIMARY KEY (`id`), UNIQUE KEY (`id`)) ENGINE=MyISAM DEFAULT CHARSET=latin1;",function()
		ES.DBQuery("SELECT name,description,doors,factions,owner,admins,members,expire_unix FROM erp_property WHERE map='"..ES.DBEscape(game.GetMap()).."';",function(c)
			if c and c[1] then
				for k,v in ipairs(c)do
					v.doors = util.JSONToTable(v.doors);
					for k,v in ipairs(v.doors)do
						v.doors[k] = ( v.doors + game.MaxPlayers() );
					end
					v.factions = util.JSONToTable(v.factions);

					ES.DebugPrint("Property loaded: ",v.name)
				end
				ERP.Properties = c;
			end
		end):wait();
	end):wait();
end)

function ERP:AddProperty(name,description,factions)
	ES.DBQuery(Format("INSERT INTO erp_property SET map='"..ES.DBEscape(game.GetMap()).."', name = '%s', description = '%s', factions = '%s'", tostring(name),tostring(description),util.TableToJSON(factions)));

	table.insert(ERP.Properties,{
		name=name,
		description=description,
		factions=factions
	})

	net.Start("ERP.property.addproperty")
		net.WriteString(name)
		net.WriteString(description)
		net.WriteTable(factions)
	net.Broadcast()

	ES.DebugPrint("New property added!",name)
end
function ERP:AddDoorToProperty(name,e)
	local t = nil;
	for k,v in pairs(ERP.Properties)do
		if v.name == name then
			t=v;
		end
	end

	if not t then
		ES.DebugPrint("No valid properties found by the name: ",name);
		return
	end;

	if not t.doors then t.doors = {} end

	table.insert(t.doors,e:EntIndex());

	local doorsSave={}
	for k,v in ipairs(t.doors)do
		table.insert(doorsSave,v-game.MaxPlayers())
	end
	ES.DBQuery(Format("UPDATE erp_property SET doors = '%s' WHERE name = '%s' AND map='"..ES.DBEscape(game.GetMap()).."'  ;", util.TableToJSON(doorsSave),tostring(name)));

	net.Start("ERP.admin.property.adddoor")
		net.WriteUInt(e:EntIndex(),16)
		net.WriteString(name)
	net.Broadcast()

	ES.DebugPrint("Door added to property",name)
end

util.AddNetworkString( "ERP.property.sync" );
hook.Add("ESPlayerReady","ERP.PlayerReady.SyncProperty",function(pl)
	net.Start("ERP.property.sync");
	net.WriteTable(ERP.Properties);
	net.Send(self);
end)

util.AddNetworkString("ERP.property.addproperty")
net.Receive("ERP.property.addproperty",function(len,pl)
	local name = net.ReadString()
	local description = net.ReadString()
	local factions = net.ReadTable()

	if not pl:IsSuperAdmin() then return end

	local property = false;
	for k,v in pairs(ERP.Properties)do
		if v.name == a[1] then
			property = v;
			break;
		end
	end
	if property then return end

	ERP:AddProperty(name,description,factions);
end)

util.AddNetworkString("ERP.property.adddoor")
net.Receive("ERP.property.adddoor",function(len,pl)
	local ent=Entity(net.ReadUInt(16))
	local property=net.ReadString()

	if not pl:IsSuperAdmin() then return end

	local property = false;
	for k,v in pairs(ERP.Properties)do
		if v.name == a[1] then
			property = v.name;
			break;
		end
	end
	if not property then
		return;
	end

	ERP:AddDoorToProperty(property,ent)
end)
