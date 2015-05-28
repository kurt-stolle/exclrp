-- sv_characters.lua
hook.Add("ESDatabaseReady","ERP.ES.CreateERPCharactersDB",function()
	ES.DBQuery("CREATE TABLE IF NOT EXISTS `erp_characters` (`id` INT unsigned NOT NULL AUTO_INCREMENT, steamid varchar(25), firstname varchar(255), lastname varchar(255), playtime int(25), job varchar(20), cash int(20) unsigned, bank int(20) unsigned, model varchar(100), jobbans varchar(6), stats varchar(255), inventory varchar(255), dead tinyint(1) default 0, PRIMARY KEY (`id`), UNIQUE KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;")
end)

-- the following fields of characters will be sent to ALL PLAYERS
local PublicFields={"firstname","lastname"}

hook.Add("ESPlayerReady","ERP.PlayerReady.SendCurrentCharacterState",function(ply)
	for k,v in ipairs(player.GetAll())do
		if v.character then
			local public={};
			for k,v in pairs(v.character)do
				if table.HasValue(PublicFields,v) then
					public[k]=v;
				end
			end
			net.Start("ERP.Character.Load")
			net.WriteEntity(v)
			net.WriteTable(public);
			net.Send(ply);
		end
	end
end)

-- create a new character
function ERP.CreateCharacter(ply,fname,lname,model)
	if not fname or not lname or not model then return end

	ES.DBQuery("SELECT id FROM erp_characters WHERE steamid = '"..ply:SteamID().."' LIMIT 4;",function(c)
		if c and #c >= 4 then
			return;
		end
		ES.DBQuery(Format("INSERT INTO erp_characters SET firstname = '%s', lastname = '%s', steamid = '%s', model = '%s', cash = 100, bank = 500;", ES.DBEscape(fname), ES.DBEscape(lname), ply:SteamID(),ES.DBEscape(model)),function()
			ERP.OpenMainMenu(ply);
		end)
	end)
end

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

	if not (...) then
		net.Start("ERP.Character.Load")
		net.WriteEntity(ply)
		net.WriteTable(ply.character);
		net.Send(ply);

		local public={};
		for k,v in pairs(ply.character)do
			if table.HasValue(PublicFields,v) then
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
			syncThis[v]=ply.character[v];
			if table.HasValue(PublicFields,v) then
				syncOthers[k]=ply.character[v];
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
	ES.DebugPrint("Collecting character "..ply:Nick().."#"..tostring(id).." from database.");

	ES.DBQuery("SELECT * FROM erp_characters WHERE steamid = '"..ply:SteamID().."' AND id = "..id.." LIMIT 1;",function(c)
		if c and c[1] then
			ply.character = table.Copy(c[1]);

			setmetatable(ply.character,CHARACTER);
			CHARACTER.__index = CHARACTER;

			ply.character.Player = ply;
			ply.character.inventory = ERP.DecodeInventory(ply.character.inventory);

			ply:KillSilent();
			ply:Spawn();

			ERP.SyncCharacter(ply);

			ES.DebugPrint("Successfully loaded character "..ply:Nick().."#"..tostring(id));
		else
			ES.DebugPrint("No character, nigga.")
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
		if not v then continue end
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
	ES.DBQuery("SELECT * FROM `erp_characters` WHERE steamid = '"..ply:SteamID().."' LIMIT 4;",function(c)
		net.Start("ERP.Character.OpenMenu");
		net.WriteTable(c or {});
		net.Send(ply);
	end)
end
