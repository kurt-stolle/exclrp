ERP.Properties = {};
ERP.OwnedProperty = {};

local doors = {
	"prop_door_rotating",
	"func_door",
	"func_door_rotating"
};

util.AddNetworkString( "ERPSynchProperty" ) 

function ERP.LoadProperty()
	ES.DebugPrint("(re)loading properties.")
	ES.DBQuery("SELECT * FROM erp_property WHERE map='"..ES.DBEscape(game.GetMap()).."';",function(c)	
		if c and c[1] then
			for k,v in pairs(c)do
				v.doors = (string.Explode("|",(v.doors or "")) or {});
				for s,d in pairs(v.doors)do
					if tonumber(d) then
						d = tonumber(d);
					else
						table.remove(v.doors,s);
					end
				end
			end
			ERP.Properties = c;
			for k,v in pairs(c) do
				for a,b in pairs(v.doors or {}) do
					Entity(b).property = k;
				end
			end
			for k,v in pairs(player.GetAll())do
				v:SynchProperty();
			end
		end
	end)
	ES.DBWait();
end
ES.DBQuery("CREATE TABLE IF NOT EXISTS `erp_property` (`id` SMALLINT(5) unsigned NOT NULL, map varchar(255), name varchar(20), description varchar(255), factionRestriction varchar(10), doors varchar(255), PRIMARY KEY (`id`), UNIQUE KEY (`id`)) ENGINE=MyISAM DEFAULT CHARSET=latin1;",ERP.LoadProperty);

function ERP:AddProperty(name,description,...)
	ES.DBQuery(Format("INSERT INTO erp_property SET map='"..ES.DBEscape(game.GetMap()).."', name = '%s', description = '%s', factionRestriction = '%s'", tostring(name),tostring(description),string.Implode("|",({...})) or "nil"));
	ERP.LoadProperty();
end
function ERP:AddDoorToProperty(name,e)
	local t = nil;
	for k,v in pairs(ERP.Properties)do
		if v.name == name then
			t=v;
		end
	end
	if not t then 
		print("No valid properties found by the name: "..name);
		PrintTable(ERP.Properties);
		return 
	end;
	
	if not t.doors then t.doors = {} end
	table.insert(t.doors,e:EntIndex());
	ES.DBQuery(Format("UPDATE erp_property SET doors = '%s' WHERE name = '%s' AND map='"..ES.DBEscape(game.GetMap()).."'  ;", string.Implode("|",t.doors),tostring(name)),function(r) 
		ERP.LoadProperty();
	end);
end
local pmeta = FindMetaTable("Player");
function pmeta:SynchProperty()
	net.Start("ERPSynchProperty");
	net.WriteTable(ERP.Properties);
	net.WriteTable(ERP.OwnedProperty);
	net.Send(self);
end

concommand.Add("excl_admin_addproperty",function(p,c,a)
	if not p:IsSuperAdmin() then return end

	local property = false;
	for k,v in pairs(ERP.Properties)do
		if v.name == a[1] then
			property = v;
			break;
		end
	end
	if not property then
		property = ERP:AddProperty(a[1],a[2],a[3] or nil, a[4]  or nil, a[5] or nil);
		ES.DebugPrint("property created");
		return;
	end		
end)
concommand.Add("excl_admin_adddoor",function(p,c,a)
	if not p:IsSuperAdmin() or not IsValid(p:GetEyeTrace().Entity) or not table.HasValue(doors,p:GetEyeTrace().Entity:GetClass()) then return end

	local property = false;
	for k,v in pairs(ERP.Properties)do
		if v.name == a[1] then
			property = v;
			break;
		end
	end
	if not property then
		return;
	end		
	
	ERP:AddDoorToProperty(a[1],p:GetEyeTrace().Entity)
end)

function pmeta:GiveProperty(name)
	local pr = false;		
	for k,v in pairs(ERP.Properties)do
		if v.name == name then
			pr = k;
		end
	end
	if not pr then return end
	ERP.OwnedProperty[pr] = {nick = self:GetRPNameFull(), id = self:UniqueID()};
	for k,v in pairs(player.GetAll())do
		v:SynchProperty();
	end
end	
concommand.Add("excl_buyproperty",function(p)
	if IsValid(p) and p:IsLoaded() and IsValid(p:GetEyeTrace().Entity) and p:GetEyeTrace().Entity.property and !ERP.OwnedProperty[p:GetEyeTrace().Entity.property] and p:GetEyeTrace().HitPos:Distance(p:EyePos()) < 100 then
		if( p.character:GetCash() - (50+(#ERP.Properties[p:GetEyeTrace().Entity.property].doors*6)) < 0 )then 
			p:ESSendNotification("generic","You do not have enough cash on you.");
			return;
		end
		p:AddMoney(-(50+(#ERP.Properties[p:GetEyeTrace().Entity.property].doors*6)));
		p:GiveProperty(ERP.Properties[ p:GetEyeTrace().Entity.property ].name);
		p:ESSendNotification("generic","The property has been bought.");
	end
end)
	
concommand.Add("excl_lockdoor",function(p)
	if IsValid(p) and p:IsLoaded() and IsValid(p:GetEyeTrace().Entity) and p:GetEyeTrace().Entity.property and ERP.OwnedProperty[p:GetEyeTrace().Entity.property] and ERP.OwnedProperty[p:GetEyeTrace().Entity.property].id and ERP.OwnedProperty[p:GetEyeTrace().Entity.property].id==p:UniqueID() and p:GetEyeTrace().HitPos:Distance(p:EyePos()) < 100 then
		p:EmitSound("doors/door_latch2.wav")
		p:GetEyeTrace().Entity:Fire("lock", "", 0)
	end
end)
concommand.Add("excl_unlockdoor",function(p)
	if IsValid(p) and p:IsLoaded() and IsValid(p:GetEyeTrace().Entity) and p:GetEyeTrace().Entity.property and ERP.OwnedProperty[p:GetEyeTrace().Entity.property] and ERP.OwnedProperty[p:GetEyeTrace().Entity.property].id and ERP.OwnedProperty[p:GetEyeTrace().Entity.property].id==p:UniqueID() and p:GetEyeTrace().HitPos:Distance(p:EyePos()) < 100 then
		p:EmitSound("doors/door_latch3.wav")
		p:GetEyeTrace().Entity:Fire("unlock", "", 0)
	end
end)
