-- Only load ExclRP when ExclServer is installed. The gamemode will not function correctly when ExclServer is not installed.
if not ES then
	Error("ExclServer not installed, aborting gamemode startup.");
end
ES.DebugPrint("Loading ExclRP version "..ERP.Version);

-- Derive from Sandbox.
DeriveGamemode("sandbox")

-- I prefer using ERP instead of GM or GAMEMODE.
ERP = {}
setmetatable(ERP,{
	__index = function(tbl,key)
		return rawget(GM or GAMEMODE,key);
	end,
	__newindex = function(tbl,key,value)
		return rawset(GM or GAMEMODE,key,value);
	end
})

-- TODO: Load these variables from the .txt file.
ERP.Name = "ExclRP";
ERP.Author = "Excl";
ERP.Version = "1";

local function exclQuickInclude(file,folder)
	folder = folder or "core/"
	
	ES.DebugPrint("Including file: "..folder..file);
	
	if string.Left(file,3) == "cl_" then
		if SERVER then
			AddCSLuaFile(folder..file);
		else
			include(folder..file);
		end
		return;
	elseif string.Left(file,3) == "sv_" then
		if SERVER then
			include(folder..file)
		end
		return;
	else -- sh_ or nothing
		if SERVER then
			include(folder..file);
			AddCSLuaFile(folder..file);
		else
			include(folder..file);
		end
		return;
	end
end
exclQuickInclude "sh_player_meta.lua";
exclQuickInclude "sh_jobs.lua";
exclQuickInclude "sv_mysql.lua";
exclQuickInclude "cl_drawguns.lua";
exclQuickInclude "sv_player.lua";
exclQuickInclude "sv_player_meta.lua";
exclQuickInclude "cl_player.lua";
exclQuickInclude "sh_characters.lua";
exclQuickInclude "sh_properties.lua";
exclQuickInclude "cl_vgui.lua";
exclQuickInclude "cl_mainmenu.lua";
exclQuickInclude "cl_ingamemenu.lua";
exclQuickInclude "sh_util.lua";
exclQuickInclude "cl_notification.lua"
exclQuickInclude "cl_inventorymenu.lua";
exclQuickInclude "sh_items.lua";
exclQuickInclude "sh_inventory.lua";
exclQuickInclude "cl_actionmenu.lua";

-- Automatically load all items, for modularity.
for k,v in pairs(file.Find("exclrp/gamemode/items/*.lua","LUA"))do
	if SERVER then
		AddCSLuaFile("items/"..v);
	end
	include("items/"..v);
end