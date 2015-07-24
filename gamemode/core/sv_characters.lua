-- sv_characters.lua
hook.Add("ESDatabaseReady","ERP.ES.CreateERPCharactersDB",function()
	ES.DBQuery("CREATE TABLE IF NOT EXISTS `erp_characters` (`id` INT unsigned NOT NULL AUTO_INCREMENT, steamid varchar(25) NOT NULL, firstname varchar(255), lastname varchar(255), playtime int(25) unsigned default 0, job varchar(20), joblevel int unsigned default 0, cash int(20) unsigned, bank int(20) unsigned, model varchar(100), jobbans varchar(6), stats varchar(255), inventory MEDIUMTEXT, deathTime int(32) unsigned default 0, arrestTime int(32) unsigned default 0, gang varchar(255), clothing varchar(255), PRIMARY KEY (`id`), UNIQUE KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;")
end)

-- the following fields of characters will be sent to ALL PLAYERS
local PublicFields={"firstname","lastname","job","joblevel"}

-- create a new character
function ERP.CreateCharacter(ply,fname,lname,model)
	if ply._erp_isCreatingCharacter or not fname or not lname or not model then return end

	ply._erp_isCreatingCharacter=true;

	ES.DBQuery("SELECT id FROM erp_characters WHERE steamid = '"..ply:SteamID().."' LIMIT 4;",function(c)
		if c and #c >= 4 then
			ply._erp_isCreatingCharacter=false;
			return;
		end
		local inv=ERP.Inventory();
		inv:SetWidth(12)
		inv:SetHeight(8)

		ES.DBQuery(Format("INSERT INTO erp_characters SET firstname = '%s', lastname = '%s', steamid = '%s', model = '%s', cash = 100, bank = 500, inventory = '%s';", ES.DBEscape(fname), ES.DBEscape(lname), ply:SteamID(),ES.DBEscape(model),ES.DBEscape(ERP.EncodeInventory(inv))),function()
			ply._erp_isCreatingCharacter=false;
			ERP.OpenMainMenu(ply);
		end)
	end)
end

-- player by ID
function ERP.FindPlayerByCharacterID(id)
	if not id then return end

	for k,v in ipairs(player.GetAll())do
		if v:IsLoaded() and v:GetCharacter():GetID() == id then
			return v;
		end
	end

	return NULL
end

--Networking
util.AddNetworkString("ERP.Character.New")
net.Receive("ERP.Character.New",function(len,ply)
	if not IsValid(ply) or ply:IsLoaded() then return end

	local firstName = net.ReadString();
	local lastName = net.ReadString();
	local model = net.ReadUInt(8);

	if not firstName or not lastName or not model then return end

	model=ERP.GetAllowedCharacterModels()[model];

	if not model then return end

	ERP.CreateCharacter(ply,firstName,lastName,model)
end)

util.AddNetworkString("ERP.Character.Load");
util.AddNetworkString("ERP.Character.Update");
function ERP.SyncCharacter(ply,...)
	if not ply.character then return end

	local char=table.Copy(ply.character);
	char.inventory = ERP.EncodeInventory(char.inventory)

	if not (...) then
		net.Start("ERP.Character.Load")
		net.WriteEntity(ply)
		net.WriteTable(char);
		net.Send(ply);

		local public={};
		for k,v in pairs(char) do
			if table.HasValue(PublicFields,k) then
				public[k]=v;
			end
		end
		net.Start("ERP.Character.Load")
		net.WriteEntity(ply)
		net.WriteTable(public);
		net.SendOmit(ply);
	else
		local syncThis={};
		local syncOthers={};
		for k,v in ipairs{...}do
			syncThis[v]=char[v];
			if table.HasValue(PublicFields,v) then
				syncOthers[k]=char[v];
			end
		end

		net.Start("ERP.Character.Update");
		net.WriteEntity(ply)
		net.WriteTable(syncThis);
		net.Send(ply);

		net.Start("ERP.Character.Update");
		net.WriteEntity(ply)
		net.WriteTable(syncOthers);
		net.SendOmit(ply);
	end
end

local CHARACTER=FindMetaTable("Character");
function ERP.LoadCharacter(ply,id)
	if ply._erp_isLoadingCharacter or ply:IsLoaded() then return end

	ply._erp_isLoadingCharacter=true

	ES.DebugPrint("Collecting character "..ply:Nick().."#"..tostring(id).." from database.");

	for k,v in ipairs(player.GetAll())do
		if v:IsLoaded() then
			local public={};
			for _k,_v in pairs(v.character)do
				if table.HasValue(PublicFields,_k) then
					public[_k]=_v;
				end
			end
			net.Start("ERP.Character.Load")
			net.WriteEntity(v)
			net.WriteTable(public);
			net.Send(ply);
		end
	end

	ES.DBQuery("SELECT * FROM erp_characters WHERE steamid = '"..ply:SteamID().."' AND id = "..id.." LIMIT 1;",function(c)
		if c and c[1] then
			c=c[1];

			ply._erp_isLoadingCharacter=false;

			ES.DebugPrint("Player loaded! ",c)

			local time;

			time = tonumber(c.arrestTime)
			if time and time > 0 then
				time = (time + ERP.Config["arrest_time"]) - os.time()

				ES.DebugPrint("Arrest time found: "..time)

				if time > 0 then
					ply:CreateErrorDialog("Character is in custody. Wait "..math.ceil(time/60).." more minutes.");
					return
				end
			end

			time = tonumber(c.deathTime)
			if time and time > 0 then
				time = (time + ERP.Config["death_time"]) - os.time();

				ES.DebugPrint("Death time found: "..time)

				if time > 0 then
					ply:CreateErrorDialog("Character is dead. Wait "..math.ceil(time/60).." more minutes.");
					return
				end
			end

			ply.character = c;

			setmetatable(ply.character,CHARACTER);
			CHARACTER.__index = CHARACTER;

			ply.character.Player = ply;
			ply.character.inventory = ERP.DecodeInventory(ply.character.inventory);

			if ply.character.gang then
				ERP.LoadGang(ply.character.gang)
			end

			ply:KillSilent();
			ply:Spawn();

			ERP.SyncCharacter(ply);

			ES.DebugPrint("Successfully loaded character "..ply:Nick().."#"..tostring(id));
		else
			ply:CreateErrorDialog("Failed to load character. Contact a developer.");
			ply._erp_isLoadingCharacter=false
		end
	end)
end

util.AddNetworkString("ERP.Character.Select")
net.Receive("ERP.Character.Select",function(len,ply)
	if not IsValid(ply) or ply:IsLoaded() then return end

	local char_id = net.ReadUInt(16);

	if not char_id then return end

	ES.DebugPrint(ply," is selecting character ",char_id)

	ERP.LoadCharacter(ply,char_id);
end)

function ERP.SaveCharacter(ply,...)
	if not ply.character then return end

	local query;

	local v;
	for _,k in ipairs{...}do
		v=ply.character[k];
		if not v then
			continue
		elseif k == "inventory" and type(v) == "table" then
			v=ERP.EncodeInventory(v);
		end
		if type(v) == "string" then
			v="'"..ES.DBEscape(v).."'";
		else
			v=tostring(v);
		end

		if not query then
			query={};
		end

		table.insert(query,"`"..tostring(k).."`="..v);
	end

	if not query then return end

	ES.DBQuery("UPDATE erp_characters SET "..table.concat(query,",").." WHERE id="..ply.character:GetID()..";");

	ERP.SyncCharacter(ply,...);
end

util.AddNetworkString("ERP.Character.OpenMenu")
function ERP.OpenMainMenu(ply)
	if ply._erp_isOpeningMainMenu then return end

	ply._erp_isOpeningMainMenu=true
	ES.DBQuery("SELECT * FROM `erp_characters` WHERE steamid = '"..ply:SteamID().."' LIMIT 4;",function(c)
		ply._erp_isOpeningMainMenu=false
		net.Start("ERP.Character.OpenMenu");
		net.WriteTable(c or {});
		net.Send(ply);
	end)
end

util.AddNetworkString("ERP.Character.UnLoad")
net.Receive("ERP.Character.UnLoad",function(len,ply)
	ply:UnLoad();
	net.Start("ERP.Character.UnLoad");
	net.WriteEntity(ply);
	net.Broadcast();
end)

util.AddNetworkString("ERP.Character.ReorganizeInventory")
net.Receive("ERP.Character.ReorganizeInventory",function(len,ply)
	if not ply:IsLoaded() then return end

	local item = ERP.Items[net.ReadString()]
	local xOld = net.ReadUInt(8)
	local yOld = net.ReadUInt(8)
	local xNew = net.ReadUInt(8)
	local yNew = net.ReadUInt(8)

	if not item or not xOld or not yOld or not xNew or not yNew then return end

	ply:GetCharacter():MoveItem(item,xOld,yOld,xNew,yNew)
end)

util.AddNetworkString("ERP.Character.DropFromInventory")
net.Receive("ERP.Character.DropFromInventory",function(len,ply)
	if not ply:IsLoaded() then return end

	local item = ERP.Items[net.ReadString()]
	local x = net.ReadUInt(8)
	local y = net.ReadUInt(8)

	if not item or not x or not y then return end

	ply:GetCharacter():DropItem(item,x,y)
end)
