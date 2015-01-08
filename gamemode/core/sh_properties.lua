
ERP.Properties = {};
ERP.OwnedProperty = {};

local doors = {
	"prop_door_rotating",
	"func_door",
	"func_door_rotating"};
if SERVER then
	util.AddNetworkString( "ERPSynchProperty" ) 
	
	function ERP:LoadProperty()
		print("Loading properties.")
		ES.DBQuery("SELECT * FROM es_erp_property_"..ES.DBEscape(game.GetMap())..";",function(c)	
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
	end
	hook.Add("Initialize","exclInitProperties",function()
		ERP:LoadProperty();
	end)
	function ERP:AddProperty(name,description,...)
		ES.DBQuery(Format("INSERT INTO es_erp_property_"..ES.DBEscape(game.GetMap()).." SET name = '%s', description = '%s', factionRestriction = '%s'", tostring(name),tostring(description),string.Implode("|",({...})) or "nil"));
		ERP:LoadProperty();
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

		ES.DBQuery(Format("UPDATE es_erp_property_"..ES.DBEscape(game.GetMap()).." SET doors = '%s' WHERE name = '%s'  ;", string.Implode("|",t.doors),tostring(name)),function(r) 
			ERP:LoadProperty();
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
			print("property created");
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
			if( p:GetMoney() - (50+(#ERP.Properties[p:GetEyeTrace().Entity.property].doors*6)) < 0 )then 
				p:SendNotification("You do not have enough cash on you.","error");
				return;
			end
			p:AddMoney(-(50+(#ERP.Properties[p:GetEyeTrace().Entity.property].doors*6)));
			p:GiveProperty(ERP.Properties[ p:GetEyeTrace().Entity.property ].name);
			p:SendNotification("The property has been bought.","generic");
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
end
if CLIENT then
	availableProperty = {};
	net.Receive("ERPSynchProperty",function(len)
		ERP.Properties = net.ReadTable();
		for k,v in pairs(ERP.Properties) do
			if v.doors then
				for a,b in pairs(v.doors) do
					if tonumber(b) then
						availableProperty[tonumber(b)] = k;
						print(b);
					end
				end
			end
		end
		ERP.OwnedProperty = net.ReadTable();
	end)
	
	
	
	
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
			
			draw.SimpleTextOutlined(ERP.Properties[availableProperty[e:EntIndex()]].name or "Error! Unidentified property!","TargetID",p.x,p.y,Color(255,255,255,alpha),1,1,1,Color(0,0,0,alpha));
			if ERP.OwnedProperty[availableProperty[e:EntIndex()]] then
				draw.SimpleTextOutlined("Owned by: "..ERP.OwnedProperty[availableProperty[e:EntIndex()]].nick,"DermaDefaultBold",p.x,p.y+25,Color(255,255,255,alpha),1,1,1,Color(0,0,0,alpha));
			else
				draw.SimpleTextOutlined("Press C to rent","DermaDefaultBold",p.x,p.y+25,Color(200,200,200,alpha),1,1,1,Color(0,0,0,alpha));
				draw.SimpleTextOutlined("This property costs $"..tostring(50+(#ERP.Properties[availableProperty[e:EntIndex()]].doors*6))..",- per hour.","DermaDefaultBold",p.x,p.y+40,Color(200,200,200,alpha),1,1,1,Color(0,0,0,alpha));
			end
		else
			if alpha > .5 then
				alpha = Lerp(0.1,alpha,0);
			end
		end
	end);
end