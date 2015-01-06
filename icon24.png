GM.Name = "Excl's Roleplay";
GM.Author = "Excl (_NewBee)"
GM.Version = "0.5";

DeriveGamemode "sandbox";
Msg("\n")
ES:DebugPrint("Loading ExclRP...")

local function exclQuickInclude(file,folder)
	folder = folder or "core/"
	
	ES:DebugPrint("Including file: "..folder..file);
	
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
exclQuickInclude "cl_gmodcompatability.lua";

for k,v in pairs(file.Find("exclrp/gamemode/items/*.lua","LUA"))do
	if SERVER then
		AddCSLuaFile("items/"..v);
	end
	include("items/"..v);
end
ES:DebugPrint("done!\n")