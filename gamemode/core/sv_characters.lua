-- sv_characters.lua
ES.DBQuery("CREATE TABLE IF NOT EXISTS `erp_characters` (`id` SMALLINT(5) unsigned NOT NULL, steamid varchar(25), firstname varchar(255), lastname varchar(255), playtime int(25), job varchar(20), cash int(20) unsigned, bank int(20) unsigned, model varchar(100), jobbans varchar(6), stats varchar(255), inventory varchar(255), PRIMARY KEY (`id`), UNIQUE KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;")

function ERP.CreateCharacter(ply,fname,lname,model)
	if not fname or not lname or not model then return end

	ES.DBQuery("SELECT id FROM erp_characters WHERE steamid = '"..ply:SteamID().."' LIMIT 4;",function(c)
		if #c >= 4 then 
			return;
		end
		ES.DBQuery(Format("INSERT INTO erp_characters SET firstname = '%s', lastname = '%s', steamid = '%s', model = '%s', cash = 100 , bank = 500;", ES.DBEscape(fname), ES.DBEscape(lname), ply:SteamID(),ES.DBEscape(model)),function()
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
		net.WriteTable(ply.character);
		net.Send(ply);
	else
		local syncThis={};
		for k,v in ipairs{...}do
			syncThis[v]=ply.character[v];
		end

		net.Start("ERP.Character.Update");
		net.WriteTable(syncThis);
		net.Send(ply);
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
			ply:Spawn();	

			ERP.SyncCharacter(ply);		

			ES.DebugPrint("Successfully loaded character "..ply:Nick().."#"..tostring(id));
		end
	end)
end

util.AddNetworkString("ERP.Character.Select")
net.Receive("ERP.Character.Select",function(len,ply)
	if not IsValid(ply) or ply:IsLoaded() then return end

	local char_id = net.ReadUInt(4);

	if not char_id then return end

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
			v="'"..v.."'";
		else
			v=tostring(v);
		end

		if not query then
			query={};
		end

		table.insert(query,"`"..tostring(k).."`="..ES.DBEscape(v));
	end

	if not query then return end
	
	ES.DBQuery("UPDATE erp_characters SET "..table.concat(query,",").." WHERE id="..ply.character:GetID()..";");

	ERP.SyncCharacter(ply,...);
end

util.AddNetworkString("ERP.Character.OpenMenu")
function ERP.OpenMainMenu(ply)
	ES.DBQuery("SELECT * FROM erp_characters WHERE steamid = '"..ply:SteamID().."' LIMIT 4;",function(c)
		net.Start("ERP.Character.OpenMenu");
		net.WriteTable(c or {});
		net.Send(ply);
	end)
end